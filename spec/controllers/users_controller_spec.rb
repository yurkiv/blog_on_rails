require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do

  let(:user) { FactoryGirl.create(:user, email: "email@email.com") }

  let(:valid_session) do
    user.add_role :admin
    sign_in user
  end

  let(:invalid_session) do
    user.add_role :user
    sign_in user
  end

  let(:user_attributes) do
    FactoryGirl.attributes_for(:user, roles: "user")
  end

  let(:admin_attributes) do
    FactoryGirl.attributes_for(:user, roles: "admin")
  end

  describe "GET #index" do
    context "when a guest user" do
      it "assigns all users as @users" do
        user = FactoryGirl.create(:user)
        get :index, {}
        expect(assigns(:users)).to_not include(user)
      end
    end

    context "when a signed user" do
      it "assigns all users as @users" do
        user = FactoryGirl.create(:user)
        get :index, {}, invalid_session
        expect(assigns(:users)).to_not include(user)
      end
    end

    context "when a admin" do
      it "assigns all users as @users" do
        user = FactoryGirl.create(:user)
        get :index, {}, valid_session
        expect(assigns(:users)).to include(user)
      end
    end
  end

  describe "POST #create" do
    context "when a guest user" do
      it "not creates a new User" do
        expect {
          post :create, {:user => user_attributes}
        }.to change(User, :count).by(0)
      end
    end

    context "when a signed user" do
      it "not creates a new User" do
        expect {
          post :create, {:user => user_attributes}, invalid_session
        }.to change(User, :count).by(1)
      end
    end

    context "when a admin" do
      it "creates a new User" do
        expect {
          post :create, {:user => user_attributes}, valid_session
        }.to change(User, :count).by(2)
      end

      it "newly created user has role 'user'" do
        post :create, {:user => user_attributes}, valid_session
        expect(assigns(:user).has_role? :user).to eq true
      end

      it "newly created user has role 'admin'" do
        post :create, {:user => admin_attributes}, valid_session
        expect(assigns(:user).has_role? :admin).to eq true
      end

      it "redirects to the created article" do
        post :create, {:user => user_attributes}, valid_session
        expect(response).to redirect_to(admin_users_path)
      end
    end

  end

end
