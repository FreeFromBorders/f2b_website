class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  field :images, type: Array
  field :message, type: String
  field :location, type: String
  field :time, type: Time
  field :causes, type: Array
  field :like_count, type: Integer
  field :share_count, type: Integer
  field :source, type: String

  belongs_to :user
  has_many :comments, dependent: :destroy

  index({message:1},{unique:true})
end
