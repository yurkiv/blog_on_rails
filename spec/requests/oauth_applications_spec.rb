require 'rails_helper'

RSpec.describe 'Applications' do
  let(:user) { FactoryGirl.create(:user, email: "email@email.com") }

  let(:valid_session) do
    user.add_role :admin
    login_as(user, emal: "email@email.com", password: "11111111")
  end

  let(:invalid_session) do
    user.add_role :user
    login_as(user, emal: "email@email.com", password: "11111111")
  end

  describe "GET /oauth/applications" do
    context "when a guest user" do
      it "redirect to sign in page" do
        get oauth_applications_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when a signed user" do
      it "redirect to sign in page" do
        invalid_session
        get oauth_applications_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when a admin" do
      it "assigns all users as @users" do
        valid_session
        get oauth_applications_path
        expect(response).to have_http_status(200)
      end
    end
  end

end
