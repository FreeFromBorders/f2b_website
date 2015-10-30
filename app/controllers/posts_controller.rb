class PostsController < ApplicationController
	def index
	end

	def save_posts_from_facebook_page
		if user_signed_in?
			id=params[:fb_id]
			access_token=params[:access_token]
			fb_graph=FacebookGraph.new(id,access_token)
			fb_graph.get_posts_with_comments().each do |fb_post|
				post=current_user.posts.create(
					:images=>fb_post['images'],
					:message=>fb_post['message'],
					:time=>fb_post['time'],
					:like_count=>fb_post['like_count'],
					:share_count=>fb_post['shares_count'],
					:source=>fb_post['source'],
					)
				post.save
				fb_post['comments'].each do |fb_comment|
					comment=post.comments.create(
						:like_count=>fb_comment['like_count'],
						:time=>fb_comment['time'],
						:message=>fb_comment['message'],
						:user_id=>post.user_id
						)
					comment.save
				end
			end
			render json: current_user.posts
		else
			head :forbidden
		end
	end

end
