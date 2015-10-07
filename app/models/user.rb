class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :articles, dependent: :destroy

  after_create :assign_default_role

  ROLES = %w[admin user]

  private
    def assign_default_role
      add_role(:user) if self.roles.blank?
    end
end
