require 'rails_helper'

RSpec.describe Article, type: :model do

  before do
    @user=User.new(email: "user@example.com", password: "12345678")
    @user.save
    @article = Article.new(title: "test title", content: "test content", user_id: @user.id, user: @user)
    @article.save
  end

  subject { @article }

  it { should respond_to(:title) }
  it { should respond_to(:content) }

  it "should be valid" do
    expect(@article).to be_valid
  end

  it "should destroy articles associated with user" do
      articles = @user.articles.to_a
      @user.destroy
      expect(articles).not_to be_empty
      articles.each do |article|
        expect(Article.where(id: article.id)).to be_empty
      end
  end

  describe "when title is not present" do
    before { @article.title = "" }
    it { should_not be_valid }
  end

  describe "when content is not present" do
    before { @article.content = "" }
    it { should_not be_valid }
  end

  describe "when title is too short" do
    before { @article.title = 5 }
    it { should_not be_valid }
  end

  describe "when content is too short" do
    before { @article.content = 5 }
    it { should_not be_valid }
  end

end
