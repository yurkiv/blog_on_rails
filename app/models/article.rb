class Article < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :title, :content, presence: true, length: { minimum: 5 }
end
