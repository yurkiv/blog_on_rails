class Article < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  validates :title, :content, presence: true, length: { minimum: 5 }
end
