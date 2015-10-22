require 'test_helper'

class PostsControllerTest < ActionController::TestCase
	include Devise::TestHelpers
  # test "the truth" do
  #   assert true
  # end

  test "should fetch facebook post" do
  	sign_in User.find_by_email('humansofnewyork@facebook.com')
  	get(:save_posts_from_facebook_page,{'id'=>'humansofnewyork'},{'access_token'=>'CAACEdEose0cBAGt7qJuVWnZCOMpIuKgW41mg7QSxCraZBZBkLxGZCv3jAYkZBCB7tZCV9e2NZBt7IEzENVdlxXuMJZB6IZC5dOuoMKSqGcfDv1n4JtzUyimtmLJATau28gEEq0utAtHB2JYaLwuZCwhWyPIawG0QsOTdyYprYQByvnFK5bLx3EyHU2trJMQdzh9PIKZBH8j6I4CqzPyh0r5LE0GjH4WQultTkoZD'})
  	assert_response :success
  end
end
