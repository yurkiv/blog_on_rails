require 'rails_helper'

RSpec.feature 'Articles', type: :feature do

  let!(:user) { FactoryGirl.create(:user, email: "email@email.com") }
  let!(:category) { FactoryGirl.create(:category, name: 'Category 1') }

  let!(:valid_session) do
    user.add_role :user
    login_as(user, emal: "email@email.com", password: "11111111")
  end

  it 'should list the article titles on the index' do

    article2 = FactoryGirl.create(:article, title: 'Test Article2', user_id: user.id, category_id: category.id)
    article3 = FactoryGirl.create(:article, title: 'Test Article3', user_id: user.id, category_id: category.id)
    article4 = FactoryGirl.create(:article, title: 'Test Article4', user_id: user.id, category_id: category.id)

    visit articles_path
    expect(page).to have_content(article3.title)
  end

  it 'user create new article' do
    visit new_article_path

    fill_in 'Title', with: 'My Article'
    fill_in 'Content', with: 'My Content'
    fill_in 'Tags', with: 'tag1, tag2'

    page.select('Category 1', :from=>'Category')
    attach_file('images_', 'public/img/2.jpg')

    click_button 'Create Article'

    expect(page).to have_content('My Article')
    expect(page).to have_content('My Content')
    expect(page).to have_content('Category 1')
    expect(page).to have_content('tag1')
    expect(page).to have_content('tag2')
    expect(page).to have_css("img[src*='2.jpg']")

  end

end
