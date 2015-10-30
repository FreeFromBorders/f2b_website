class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  field :like_count, type: Integer
  field :message, type: String
  field :causes, type: Array
  field :time, type: Time

  belongs_to :user 
  belongs_to :post
end
