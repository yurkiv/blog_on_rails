require 'rails_helper'

RSpec.describe Api::V1::ArticlesController, type: :request do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:token) { FactoryGirl.create(:access_token, :resource_owner_id => user.id) }
  let!(:category) { FactoryGirl.create(:category) }

  describe "GET /articles" do
    let!(:article) { FactoryGirl.create(:article, title: "Test Article", user_id: user.id, category_id: category.id) }
    it 'returns the articles as json' do
      get api_v1_articles_path, :format => :json, :access_token => token.token
      article_titles = json.map { |a| a["title"] }

      expect(article_titles).to match_array(["Test Article"])
      expect(response).to have_http_status(200)
    end

    context "when use pagination" do
      it 'returns the paginate articles as json' do
        article2 = FactoryGirl.create(:article, title: "Test Article2", user_id: user.id, category_id: 1)
        article3 = FactoryGirl.create(:article, title: "Test Article3", user_id: user.id, category_id: 1)
        article4 = FactoryGirl.create(:article, title: "Test Article4", user_id: user.id, category_id: 1)

        get api_v1_articles_path,
          format: :json,
          access_token: token.token,
          page: "2",
          limit: "2"

        article_titles = json.map { |a| a["title"] }
        expect(article_titles).to match_array(["Test Article3", "Test Article4"])
        expect(response).to have_http_status(200)
      end
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
          article: {
              title: 'Test Article',
              content: "Test Test Test",
              category_id: "1",
              tags: [
                {
                    name: "tag1"
                },
                {
                    name: "tag2"
                }
              ],
              images: [
                  {
                      filename: "images.jpg",
                      content: "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",
                      content_type: "image/jpg"
                  }
              ]
          }

        expect(response).to have_http_status(201) #created
        expect(Article.first.title).to eq "Test Article"
        expect(json["title"]).to eq "Test Article"
        expect(json["tags"][0]["name"]).to eq "tag1"
        expect(json["images"][0]["filename"]).to include "images.jpg"
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
