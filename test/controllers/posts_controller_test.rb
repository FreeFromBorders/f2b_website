require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should fetch facebook post" do
  	sign_in users(:one)
  	get(:save_posts_from_facebook_page,{'id'=>'humansofnewyork'},{'access_token'=>Rails.application.secrets.fb_access_token})
  	assert_response :success
  end


end