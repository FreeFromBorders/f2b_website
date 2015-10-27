require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should fetch facebook post" do
  	begin
	  	@request.env["devise.mapping"]=Devise.mappings[:user]
	  	@user=FactoryGirl.create(:user)
	  	sign_in @user
	  	get(:save_posts_from_facebook_page,{:fb_id=>:humansofnewyork,:access_token=>Rails.application.secrets.fb_access_token})
	  	assert_response :success
		rescue => er
			puts er.backtrace
			raise er
		end

  end

end