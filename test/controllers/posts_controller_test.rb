require 'test_helper'

class PostsControllerTest < ActionController::TestCase
	include Devise::TestHelpers
  # test "the truth" do
  #   assert true
  # end

  test "should fetch facebook post" do
  	sign_in User.find_by_email('humansofnewyork@facebook.com')
  	get(:save_posts_from_facebook_page,{'id'=>'humansofnewyork'},{'access_token'=>'asdknasd'})
  	assert_response :success
  end
end
