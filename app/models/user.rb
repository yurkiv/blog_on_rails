class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :articles, dependent: :destroy

  after_create :assign_default_role
  # after_destroy :ensure_an_admin_remains

  private
    def assign_default_role
      add_role(:user) if self.roles.blank?
    end

    def ensure_an_admin_remains
      users = User.all
      users.each do |user|
        if user.has_role? :admin
          raise "Can't delete last user"
        end
      end

    end
end
