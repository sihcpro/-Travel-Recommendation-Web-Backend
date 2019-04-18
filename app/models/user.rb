class User < ApplicationRecord
  has_secure_password
  validates :username, :password, :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  
  before_create { generate_token(:auth_token) }
  # validate  :birthday?

  validates_presence_of :password, :on => :create
  enum role: ['Admin', 'Dev', 'User']
  enum gender: ['Nam', 'Nữ', 'Ngại quá à']

  has_many :history

  def generate_token(column)
    begin
      self[column] = SecureRandom.hex
    end while User.exists?(column => self[column])
  end
end
