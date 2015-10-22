require File.expand_path('../../../config/environment',__FILE__)
require_relative 'facebook_graph'
fb=FacebookGraph.new("humansofnewyork",Rails.application.secrets.fb_access_token)
post = Post.new(
	:images=>fb.get_posts_with_comments()[0]['images'],
	:message=>fb.get_posts_with_comments()[0]['message'],
	:time=>fb.get_posts_with_comments()[0]['time'],
	:like_count=>fb.get_posts_with_comments()[0]['like_count'],
	:share_count=>fb.get_posts_with_comments()[0]['share_count'],
	:source=>fb.get_posts_with_comments()[0]['source']
)
post.save
comment= post.comments.new(
	:like_count=>fb.get_posts_with_comments()[0]['comments'][0]['like_count'],
	:message=>fb.get_posts_with_comments()[0]['comments'][0]['message'],
	:time=>fb.get_posts_with_comments()[0]['comments'][0]['time']
	)
comment.save