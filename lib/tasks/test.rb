require File.expand_path('../../../config/environment',__FILE__)
require_relative 'facebook_graph'
fb=FacebookGraph.new("humansofnewyork","CAACEdEose0cBAPZAPO47RLcuAhXP2hA7uh42vUlDc4iRnfE391sxDID6UiofouYZCJyZC1s0uUPq8AmELT2ZAud7TkZCqHZAivvGZBJg5ZAHZBEwjh2p35lOMrQOZCtdxozTQ5YN1qRZAYb4O2Y0UkIUu0A9K3s4ur7MQAflDcvMhkWxrnqyrzAOcEp8Yejp2HDVm6GFmizWUi6errgOZB11wQLLCwYzG1XlkLUZD")
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