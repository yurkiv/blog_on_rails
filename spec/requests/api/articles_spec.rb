require 'rails_helper'

RSpec.describe Api::V1::ArticlesController, type: :request do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:token) { FactoryGirl.create(:access_token, :resource_owner_id => user.id) }

  describe "GET /articles" do
    let!(:article) { FactoryGirl.create(:article, title: "Test Article", user_id: user.id, category_id: 1) }
    it 'returns the articles as json' do
      get api_v1_articles_path, :format => :json, :access_token => token.token
      article_titles = json.map { |a| a["title"] }

      expect(article_titles).to match_array(["Test Article"])
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /articles/:id" do
    let!(:article) { FactoryGirl.create(:article, title: "Test Article", user_id: user.id, category_id: 1) }
    it "returns a requested article" do

      get api_v1_article_path(1), :format => :json, :access_token => token.token

      expect(response).to have_http_status(200)
      expect(json["title"]).to eq "Test Article"
    end
  end

  describe "POST /articles" do
    context "when user does not have access" do
      it "does not create Article" do
        post api_v1_articles_path,
          format: :json,
          article: { title: 'Test Article', content: "Test Test Test", category_id: "1"}
        expect(response).to have_http_status(401)
      end
    end

    context "when authenticated user" do
      it "creates a article" do
        post api_v1_articles_path,
          format: :json,
          access_token: token.token,
          article: { title: 'Test Article', content: "Test Test Test", category_id: "1"}

        expect(response).to have_http_status(201) #created
        expect(Article.first.title).to eq "Test Article"
      end
    end
  end

  describe "PUT /articles/:id" do
    let!(:article) { FactoryGirl.create(:article, title: "Test Article", user_id: user.id, category_id: 1) }
    context "when non authenticated user" do
      it "does not update Article" do
        put api_v1_article_path(1),
          format: :json,
          article: { title: 'Updated Article'}
        expect(response).to have_http_status(401)
      end
    end

    context "when authenticated user" do
      it "update a article" do
        put api_v1_article_path(1),
          format: :json,
          access_token: token.token,
          article: { title: 'Updated Article'}

        expect(response).to have_http_status(200)
        expect(Article.first.title).to eq "Updated Article"
      end

      it "does not update any article" do
        user2 = FactoryGirl.create(:user, email: "user2@email.com")
        token = FactoryGirl.create(:access_token, :resource_owner_id => user2.id)

        put api_v1_article_path(1),
          format: :json,
          access_token: token.token,
          article: { title: 'Updated Article'}

        expect(response).to have_http_status(403)
        expect(json["errors"]).to eq ["You are not authorized to access this page."]
      end

    end

    context "when authenticated admin user" do
      it "update any article" do
        admin_user = FactoryGirl.create(:user, email: "admin@email.com")
        admin_user.add_role :admin
        token = FactoryGirl.create(:access_token, :resource_owner_id => admin_user.id)

        put api_v1_article_path(1),
          format: :json,
          access_token: token.token,
          article: { title: 'Updated Article'}

        expect(response).to have_http_status(200)
        expect(Article.first.title).to eq "Updated Article"
      end
    end
  end

  describe "DELETE /articles/:id" do
    let!(:article) { FactoryGirl.create(:article, title: "Test Article", user_id: user.id, category_id: 1) }
    context "when non authenticated user" do
      it "does not delete Article" do
        delete api_v1_article_path(1),
          format: :json
        expect(response).to have_http_status(401)
      end
    end

    context "when authenticated user" do
      it "delete a article" do
        delete api_v1_article_path(1),
          format: :json,
          access_token: token.token

        expect(response).to have_http_status(204)
        expect(Article.all.size).to eq 0
      end

      it "does not delete any article" do
        user2 = FactoryGirl.create(:user, email: "user2@email.com")
        token = FactoryGirl.create(:access_token, :resource_owner_id => user2.id)

        delete api_v1_article_path(1),
          format: :json,
          access_token: token.token

        expect(response).to have_http_status(403)
        expect(json["errors"]).to eq ["You are not authorized to access this page."]
      end

    end

    context "when authenticated admin user" do
      it "delete any article" do
        admin_user = FactoryGirl.create(:user, email: "admin@email.com")
        admin_user.add_role :admin
        token = FactoryGirl.create(:access_token, :resource_owner_id => admin_user.id)

        delete api_v1_article_path(1),
          format: :json,
          access_token: token.token

        expect(response).to have_http_status(204)
        expect(Article.all.size).to eq 0
      end
    end
  end

end
