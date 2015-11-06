#Written for version 2.5 for official   Facebook Graph API

#Current code only fetches last 100 posts as that's the limit for one time fetch. 

class FacebookGraph
  require 'open-uri'
  require 'json'

  def initialize(id,access_token)
    @facebook_graph_url = "https://graph.facebook.com/"
    @version = "v2.5"
    @access_token = access_token
    @id = id
    @fields = "posts.limit(100){message,created_time,comments{like_count,created_time,message},full_picture,shares}"
    @url = "#{@facebook_graph_url + @version}/#{@id}?access_token=#{@access_token}&fields=#{@fields}"
    puts   @url
    @json = URI.parse(URI.encode(@url)).read
    @hash = JSON.parse(@json)
  end

  def get_id
    @hash["id"]
  end

  def get_name
    @hash["name"]
  end

  def get_likes_count_for_post(post_id)
    likes_url = "#{@facebook_graph_url + @version}/#{post_id}/likes?access_token=#{@access_token}&summary=true"
    json = URI.parse(URI.encode(likes_url)).read
    hash = JSON.parse(json)
    hash['summary']['total_count']
  end

  def get_posts_with_comments
    posts = []
    @hash["posts"]["data"].each do |fb_post|
      post = Hash.new
      post['images'] = [fb_post['full_picture']]
      post['message'] = fb_post['message']
      post['time'] = fb_post['created_time']
      post['like_count'] = self.get_likes_count_for_post(fb_post['id'])
      post['share_count'] = fb_post['shares']['count']
      post['source'] = "https://www.facebook.com/"+fb_post['id']
      post['comments'] = []
      fb_post['comments']['data'].each do |fb_comment|
        comment = Hash.new
        comment['like_count'] = fb_comment['like_count']
        comment['time'] = fb_comment['created_time']
        comment['message'] = fb_comment['message']
        post['comments'].push(comment)
      end
      posts.push(post)
    end
    posts
  end

  def save_posts_with_comments_from_facebook_page(user)
    get_posts_with_comments().each do |fb_post|
      begin
        post = user.posts.create(
          images: fb_post['images'],
          message: fb_post['message'],
          time: ['time'],
          like_count: fb_post['like_count'],
          share_count: fb_post['share_count'],
          source: fb_post['source'],
        )
        post.save
        fb_post['comments'].each do |fb_comment|
          comment = post.comments.create(
            like_count: fb_comment['like_count'],
            time: fb_comment['time'],
            message: fb_comment['message'],
            user_id: post.user_id
          )
          comment.save
        end
      rescue Moped::Errors::OperationFailure => e
        puts "Error: "+ e.message+ "\n"
        puts "Post: "+ fb_post['message']
      end
    end
  end
end