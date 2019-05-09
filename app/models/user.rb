class User < ApplicationRecord
  has_secure_password
  validates :username, :password, :email, presence: true, on: :create
  validates :email, uniqueness: { case_sensitive: false }

  before_create { generate_token(:auth_token) }
  # validate  :birthday?

  validates_presence_of :password, :on => :create
  enum role: ['admin', 'dev', 'user']
  enum gender: ['Nam', 'Nữ', 'Không']


  has_one :favorite
  has_many :histories
  has_many :suggestions
  has_many :comments


  def generate_token(column)
    begin
      self[column] = SecureRandom.hex
    end while User.exists?(column => self[column])
  end
end
