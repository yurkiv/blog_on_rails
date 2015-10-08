require 'rails_helper'

RSpec.describe Admin::CategoriesController, type: :controller do


  # This should return the minimal set of attributes required to create a valid
  # Category. As you add validations to Category, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { FactoryGirl.attributes_for(:category, name: 'Category 1') }

  let(:invalid_attributes) { FactoryGirl.attributes_for(:category, name: '') }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CategoriesController. Be sure to keep this updated too.
  let(:valid_session) do
    @user = FactoryGirl.create(:user)
    @user.add_role :admin
    sign_in @user
  end

  describe "GET #index" do
    it "assigns all categories as @categories" do
      category = Category.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:categories)).to eq([category])
    end
  end

  describe "GET #show" do
    it "assigns the requested category as @category" do
      category = Category.create! valid_attributes
      get :show, {:id => category.to_param}, valid_session
      expect(assigns(:category)).to eq(category)
    end
  end

  describe "GET #new" do
    it "assigns a new category as @category" do
      get :new, {}, valid_session
      expect(assigns(:category)).to be_a_new(Category)
    end
  end

  describe "GET #edit" do
    it "assigns the requested category as @category" do
      category = Category.create! valid_attributes
      get :edit, {:id => category.to_param}, valid_session
      expect(assigns(:category)).to eq(category)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Category" do
        expect {
          post :create, {:category => valid_attributes}, valid_session
        }.to change(Category, :count).by(1)
      end

      it "assigns a newly created category as @category" do
        post :create, {:category => valid_attributes}, valid_session
        expect(assigns(:category)).to be_a(Category)
        expect(assigns(:category)).to be_persisted
      end

      it "redirects to the created category" do
        post :create, {:category => valid_attributes}, valid_session
        expect(response).to redirect_to(admin_categories_path)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved category as @category" do
        post :create, {:category => invalid_attributes}, valid_session
        expect(assigns(:category)).to be_a_new(Category)
      end

      it "re-renders the 'new' template" do
        post :create, {:category => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { FactoryGirl.attributes_for(:category, name: 'Category 2') }

      it "updates the requested category" do
        category = Category.create! valid_attributes
        expect {
          put :update, {:id => category.to_param, :category => new_attributes}, valid_session
          category.reload
        }.to change(Category, :count).by(0)
        expect(assigns(:category)).to eq(category)
      end

      it "assigns the requested category as @category" do
        category = Category.create! valid_attributes
        put :update, {:id => category.to_param, :category => valid_attributes}, valid_session
        expect(assigns(:category)).to eq(category)
      end

      it "redirects to the category" do
        category = Category.create! valid_attributes
        put :update, {:id => category.to_param, :category => valid_attributes}, valid_session
        expect(response).to redirect_to(admin_categories_path)
      end
    end

    context "with invalid params" do
      it "assigns the category as @category" do
        category = Category.create! valid_attributes
        put :update, {:id => category.to_param, :category => invalid_attributes}, valid_session
        expect(assigns(:category)).to eq(category)
      end

      it "re-renders the 'edit' template" do
        category = Category.create! valid_attributes
        put :update, {:id => category.to_param, :category => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested category" do
      category = Category.create! valid_attributes
      expect {
        delete :destroy, {:id => category.to_param}, valid_session
      }.to change(Category, :count).by(-1)
    end

    it "redirects to the categories list" do
      category = Category.create! valid_attributes
      delete :destroy, {:id => category.to_param}, valid_session
      expect(response).to redirect_to(admin_categories_path)
    end
  end

end
