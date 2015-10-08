class Category < ActiveRecord::Base
  has_many :articles
  validates :name, length: { minimum: 5 }
end
