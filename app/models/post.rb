class Post
  include Mongoid::Document
  field :images, type: Array
  field :text, type: String
  field :location, type: String
  field :time, type: Time
  field :causes, type: Array
  field :likes, type: Number
  field :share, type: Number
  field :source, type: String

  belongs_to :user
  has_many :comments
end
