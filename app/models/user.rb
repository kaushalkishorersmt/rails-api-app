class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_create :generate_authentication_token!
  validates :auth_token, uniqueness: true

  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
  end

  def invalidate_auth_token
    self.update_columns(auth_token: nil)
  end

end
