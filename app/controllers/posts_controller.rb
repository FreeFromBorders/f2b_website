class PostsController < ApplicationController
  def index
    if user_signed_in?
      @posts=current_user.posts
    else
      @posts=Post.all
    end
  end

  def save_posts_with_comments_from_facebook_page
    id = params[:fb_id]
    access_token = params[:access_token]
    if user_signed_in?
      fb_data = FacebookGraph.new(id,access_token)
      fb_data.save_posts_with_comments_from_facebook_page(current_user)
      render json: current_user.posts
    else
      head :forbidden
    end
  end
end
