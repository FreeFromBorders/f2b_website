class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  field :like_count, type: Integer
  field :message, type: String
  field :causes, type: Array
  field :time, type: Time
  field :source, type: String

  belongs_to :user 
  belongs_to :post

  index({source: 1},{unique: true})
  
end
