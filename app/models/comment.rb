class Comment
  include Mongoid::Document
  field :likes, type: Number
  field :text, type: String
  field :causes, type: Array

  belongs_to :user
  belongs_to :post
end
