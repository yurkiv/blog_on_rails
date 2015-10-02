require 'rails_helper'

RSpec.describe User, type: :model do
  before { @user = User.new(email: "user@example.com", password: "12345678") }

  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:articles) }

  it "should be valid" do
    expect(@user).to be_valid
  end

  describe "when email is not present" do
    before { @user.email = "" }
    it { should_not be_valid }
  end

  describe "when user email is already taken" do
    before do
      user_with_same_email=@user.dup
      user_with_same_email.email.upcase
      user_with_same_email.save
    end
    it { should_not be_valid }
  end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end


end
