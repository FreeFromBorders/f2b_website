class Comment
  include Mongoid::Document
  field :likes, type: Integer
  field :text, type: String
  field :causes, type: Array

  belongs_to :user
  belongs_to :post
end
