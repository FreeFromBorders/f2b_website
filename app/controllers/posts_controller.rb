class PostsController < ApplicationController

	def index
	end

	def save_posts_from_facebook_page
		if user_signed_in?
			id=params[:fb_id]
			access_code=params[:access_code]
			fb_graph=FacebookGraph.new(id,access_code)
			fb_graph.get_posts().each do |fb_post|
				post=current_user.posts.new(
					:images=>fb_post['images'],
					:message=>fb_post['message'],
					:time=>fb_post['time'],
					:like_count=>fb_post['like_count'],
					:share_count=>fb_post['shares_count'],
					:source=>fb_post['source'],
					)
				post.save
				fb_posts['comments'].each do |fb_comment|
					comment=post.comments.new(
						:like_count=>fb_comment['like_count'],
						:time=>fb_comment['time'],
						:message=>fb_comment['message']
						)
					comment.save
				end
				redirect_to root_path
			end
		else
			head :forbidden
		end
	end

end
