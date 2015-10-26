require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do

  let(:user) { FactoryGirl.create(:user) }

  let(:valid_session) do
    sign_in user
  end

  let(:valid_attributes) do
    @category=FactoryGirl.create(:category)
    # @tag=FactoryGirl.create(:tag)
    FactoryGirl.attributes_for(:article, user_id: user.id, category_id: @category.id)
  end

  let(:invalid_attributes) { FactoryGirl.attributes_for(:article, title: 'Article', content: '') }

  describe "GET #index" do
    it "assigns all articles as @articles" do
      article = Article.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:articles)).to eq([article])
    end

    it "all articles by user" do
      article1 = Article.create! valid_attributes
      article2 = Article.create! FactoryGirl.attributes_for(:article, user_id: 999, category_id:1)
      article3 = Article.create! valid_attributes
      get :index, {user_id: 1}, valid_session
      expect(assigns(:articles)).to match_array([article1, article3])
    end

    it "all articles by category" do
      article1 = Article.create! valid_attributes
      article2 = Article.create! FactoryGirl.attributes_for(:article, user_id: 1, category_id:666)
      article3 = Article.create! valid_attributes
      get :index, {category_id: 1}, valid_session
      expect(assigns(:articles)).to match_array([article1, article3])
    end

    it "all articles by tag" do
      tag666=FactoryGirl.create(:tag, name: 'tag666')
      article1 = Article.create! valid_attributes
      article2 = Article.create! FactoryGirl.attributes_for(:article, user_id: 1, tags: [tag666.id])
      article3 = Article.create! valid_attributes
      get :index, {tag_id: 1}, valid_session
      expect(assigns(:articles)).to match_array([article1, article3])
    end
  end

  describe "GET #show" do
    it "assigns the requested article as @article" do
      article = Article.create! valid_attributes
      get :show, {:id => article.to_param}, valid_session
      expect(assigns(:article)).to eq(article)
    end
  end

  describe "GET #new" do
    it "assigns a new article as @article" do
      get :new, {}, valid_session
      expect(assigns(:article)).to be_a_new(Article)
    end
  end

  describe "GET #edit" do
    it "assigns the requested article as @article" do
      article = Article.create! valid_attributes
      get :edit, {:id => article.to_param}, valid_session
      expect(assigns(:article)).to eq(article)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Article" do
        expect {
          post :create, {:article => valid_attributes}, valid_session
        }.to change(Article, :count).by(1)
      end

      it "assigns a newly created article as @article" do
        post :create, {:article => valid_attributes}, valid_session
        expect(assigns(:article)).to be_a(Article)
        expect(assigns(:article)).to be_persisted
      end

      it "redirects to the created article" do
        post :create, {:article => valid_attributes}, valid_session
        expect(response).to redirect_to(article_path(1))
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved article as @article" do
        post :create, {:article => invalid_attributes}, valid_session
        expect(assigns(:article)).to be_a_new(Article)
      end

      it "re-renders the 'new' template" do
        post :create, {:article => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) do
        FactoryGirl.attributes_for(:article, content: 'New Content', user: user.id, category: @category.id)
      end

      it "updates the requested article" do
        article = Article.create! valid_attributes
        expect {
          put :update, {:id => article.to_param, :article => new_attributes}, valid_session
          article.reload
        }.to change(Article, :count).by(0)
        expect(assigns(:article)).to eq(article)
      end

      it "assigns the requested article as @article" do
        article = Article.create! valid_attributes
        put :update, {:id => article.to_param, :article => valid_attributes}, valid_session
        expect(assigns(:article)).to eq(article)
      end

      it "redirects to the article" do
        article = Article.create! valid_attributes
        put :update, {:id => article.to_param, :article => valid_attributes}, valid_session
        expect(response).to redirect_to(article_path(1))
      end
    end

    context "with invalid params" do
      it "assigns the article as @article" do
        article = Article.create! valid_attributes
        put :update, {:id => article.to_param, :article => invalid_attributes}, valid_session
        expect(assigns(:article)).to eq(article)
      end

      it "re-renders the 'edit' template" do
        article = Article.create! valid_attributes
        put :update, {:id => article.to_param, :article => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested article" do
      article = Article.create! valid_attributes
      expect {
        delete :destroy, {:id => article.to_param}, valid_session
      }.to change(Article, :count).by(-1)
    end

    it "redirects to the articles list" do
      article = Article.create! valid_attributes
      delete :destroy, {:id => article.to_param}, valid_session
      expect(response).to redirect_to(articles_path)
    end
  end

end
