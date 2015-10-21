class PostsController < ApplicationController

	def index
	end

	def save_posts_from_facebook
		if user_signed_in?
			id=params[:fb_id]
			access_code=params[:access_code]
			fb_graph=FacebookGraph.new(id,access_code)
		end
	end


end
