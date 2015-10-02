require 'rails_helper'
require "cancan/matchers"

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

  describe 'Abilities' do

    let(:user) { @user }
    subject { Ability.new(user) }

    context "a guest user" do
      it "cannot create article" do
        expect(subject).to_not be_able_to(:create, Article)
      end

      it "cannot update article" do
        expect(subject).to_not be_able_to(:update, Article)
      end

      it "cannot destroy article" do
        expect(subject).to_not be_able_to(:create, Article)
      end

      it "can read article" do
        expect(subject).to be_able_to(:read, Article)
      end

    end

    context "a signed user" do
      let(:user) { @user.save }
      it "can create article" do
        expect(subject).to_not be_able_to(:create, Article)
      end

      it "can update article" do
        expect(subject).to_not be_able_to(:update, Article)
      end

      it "can destroy article" do
        expect(subject).to_not be_able_to(:create, Article)
      end

      it "can read article" do
        expect(subject).to be_able_to(:read, Article)
      end

    end

      # context 'guest' do
      #   let(:user) { @user }
      #
      #   it "cannot create article" do
      #     ability = Ability.new(user)
      #     it{ should be_able_to(:manage, Article.new) }
      #     # assert ability.can?(:create, Article.new)
      #   end
      #
      #
      #
      #   #
      #   # it 'can read shares' do
      #   #   ability = Ability.new(user)
      #   #   assert ability.can?(:read, :share)
      #   # end
      # end
    end
end
