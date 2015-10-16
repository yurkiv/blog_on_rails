class Article < ActiveRecord::Base
  belongs_to :user
  belongs_to :category

  has_many :pictures, :dependent => :destroy

  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :title, :content, presence: true, length: { minimum: 5 }

  scope :search, ->(q) {where("content LIKE ? OR title LIKE ?", "%#{q}%", "%#{q}%")}

  # def self.search(search)
  #   where("content LIKE ? OR title LIKE ?", "%#{search}%", "%#{search}%")
  # end

end
