require 'rails_helper'
require 'cancan/matchers'

RSpec.describe User, type: :model do
  subject(:user) { FactoryGirl.build(:user) }

  it { expect(user).to respond_to(:email) }
  it { expect(user).to respond_to(:articles) }

  it "should be valid" do
    expect(user).to be_valid
  end

  describe "when email is not present" do
    before { user.email = "" }
    it { expect(user).to_not be_valid }
  end

  describe "when user email is already taken" do
    before do
      user_with_same_email=user.dup
      user_with_same_email.email.upcase
      user_with_same_email.save
    end
    it { expect(user).to_not be_valid }
  end

  describe "when password is not present" do
    before { user.password = user.password_confirmation = " " }
    it { expect(user).to_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { user.password_confirmation = "mismatch" }
    it { expect(user).to_not be_valid }
  end

  describe 'Abilities' do

    context "when a guest user" do
      let(:ability) { Ability.new(user) }

      it "cannot create article" do
        expect(ability).to_not be_able_to(:create, Article)
      end

      it "cannot update article" do
        expect(ability).to_not be_able_to(:update, Article)
      end

      it "cannot destroy article" do
        expect(ability).to_not be_able_to(:create, Article)
      end

      it "can read article" do
        expect(ability).to be_able_to(:read, Article)
      end
    end

    context "when a signed user" do

      let(:ability) do
        user.save
        Ability.new(user)
      end

      it "can create article" do
        expect(ability).to be_able_to(:create, Article)
      end

      it "can update article" do
        expect(ability).to be_able_to(:update, Article)
      end

      it "can destroy article" do
        expect(ability).to be_able_to(:create, Article)
      end

      it "can read article" do
        expect(ability).to be_able_to(:read, Article)
      end
    end
  end
end
