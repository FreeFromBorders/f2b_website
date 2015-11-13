require 'test_helper'

class FacebookGraphTest< ActionController::TestCase
  def setup
    @controller=PostsController.new
  end

  test "should fetch facebook post" do
    begin
      @request.env["devise.mapping"]=Devise.mappings[:user]
      @user=FactoryGirl.create(:user)
      sign_in @user
      get(:save_posts_with_comments_from_facebook_page,{fb_id: 'humansofnewyork', access_token: Rails.application.secrets.fb_access_token, number_of_posts: '20000'})
      assert_response :success
    rescue => er
      puts er.backtrace
      raise er
    end
  end
end