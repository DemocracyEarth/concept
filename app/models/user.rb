class User < ApplicationRecord

  after_initialize :init

  def init
    self.interation ||= false
  end
  validates :username, :presence => true
  validates :email, :presence => true, :uniqueness => true
  has_secure_password
end
