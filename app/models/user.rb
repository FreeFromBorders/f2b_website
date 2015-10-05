class User
  include Mongoid::Document
  field :email, type: String
  field :password, type: String
  field :links, type: Array
  field :causes, type: Array

  has_many :posts
  has_many :comments
end
