class Post
  include Mongoid::Document
  field :images, type: Array
  field :message, type: String
  field :location, type: String
  field :time, type: Time
  field :causes, type: Array
  field :likes_count, type: Integer
  field :shares, type: Integer
  field :source, type: String

  belongs_to :user
  has_many :comments

  index({message:1},{unique:true})
end
