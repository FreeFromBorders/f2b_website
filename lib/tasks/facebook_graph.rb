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

	def get_id()
		return @hash["id"]
	end

	def get_name()
		return @hash["name"]
	end

	def get_likes_count_for_post(post_id)
		likes_url=@facebook_graph_url+@version+"/"+post_id+"/likes?access_token="+@access_token+"&summary=true"
		json=URI.parse(URI.encode(likes_url)).read
		hash=JSON.parse(json)
		return hash['summary']['total_count']
	end

	def get_posts_with_comments()
		posts=[]
		@hash["posts"]["data"].each do |fb_post|
			post=Hash.new
			post['images']=[fb_post['full_picture']]
			post['message']=fb_post['message']
			post['time']=fb_post['created_time']
			post['like_count']=self.get_likes_count_for_post(fb_post['id'])
			post['share_count']=fb_post['shares']['count']
			post['source']="https://www.facebook.com/"+fb_post['id']
			post['comments']=[]
			fb_post['comments']['data'].each do |fb_comment|
				comment=Hash.new
				comment['like_count']=fb_comment['like_count']
				comment['time']=fb_comment['created_time']
				comment['message']=fb_comment['message']
				post['comments'].push(comment)
			end
			posts.push(post)
		end
		return posts
	end
end