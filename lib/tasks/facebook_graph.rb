
require File.expand_path('../../../config/environment',__FILE__)
#Written for version 2.5 for official 	Facebook Graph API

#Current code only fetches last 100 posts as that's the limit for one time fetch. 

class FacebookGraph
	require 'open-uri'
	require 'json'

	def initialize(id,access_token)
		@facebook_graph_url = "https://graph.facebook.com/"
		@version = "v2.5"
		@access_token=access_token
		@id=id
		@fields="posts.limit(3){message,created_time,comments{like_count,created_time,message},full_picture,shares}"
		@url=@facebook_graph_url+@version+"/"+id+"?access_token="+@access_token+"&fields="+@fields
		@json=URI.parse(URI.encode(@url)).read
		@hash=JSON.parse(@json)
	end

	def getID()
		return @hash["id"]
	end

	def getName()
		return @hash["name"]
	end

	def getPosts()
		return @hash["posts"]["data"]
	end

	def getNumberOfLikesforPost(post_id)
		likes_url=@facebook_graph_url+@version+"/"+post_id+"/likes?access_token="+@access_token+"&summary=true"
		json=URI.parse(URI.encode(likes_url)).read
		hash=JSON.parse(json)
		return hash['summary']['total_count']
	end

	def savePostsToUser(user)
		self.getPosts().each do |post|
			ffb_post=Post.new(
				:images=>[post['full_picture']],
				:text=>post['message'],
				:time=>post['created_time'],
				:likes=>self.getNumberOfLikesforPost(post['id']),
				:shares=>post['shares']['count'],
				:source=>"https://www.facebook.com/"+post['id']
				)
			ffb_post.save
		end		
	end
end