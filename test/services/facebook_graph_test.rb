require 'test_helper'

class FacebookGraphTest< ActionController::TestCase
	def setup
		@controller=PostsController.new
	end

	test "should fetch facebook post" do
  	begin
	  	@request.env["devise.mapping"]=Devise.mappings[:user]
	  	get(:save_posts_with_comments_from_facebook_page,{:fb_id=>:humansofnewyork,:access_token=>Rails.application.secrets.fb_access_token})
	  	assert_response :forbidden
		rescue => er
			puts er.backtrace
			raise er
		end
	end
end