#Written for version 2.5 for official   Facebook Graph API

#Current code only fetches last 100 posts as that's the limit for one time fetch. 

class FacebookGraph
  require 'open-uri'
  require 'json'

  def initialize(id, access_token, number_of_posts=100)
    @facebook_graph_url = "https://graph.facebook.com/"
    @version = "v2.5"
    @access_token = access_token
    @id = id
    @total_number_of_article = number_of_posts.to_i
    @number_of_posts_remaining = @total_number_of_article
    if @number_of_posts_remaining <= 100
      @fields = "posts.limit(#{number_of_posts}){message,created_time,comments{like_count,created_time,message},full_picture,shares}"  
    else
      @fields = "posts.limit(100){message,created_time,comments{like_count,created_time,message},full_picture,shares}"
    end
    @url = "#{@facebook_graph_url + @version}/#{@id}?access_token=#{@access_token}&fields=#{@fields}"
    @json = fetch_url(@url)
    @initial_hash = hash_json(@json)
    @page_iterator = @initial_hash
    @progress_bar=ProgressBar.create(title: "Downloading Posts from #{id}", total: @total_number_of_article)
  end

  def fetch_url(url)
    begin
      puts "Fetching url: #{url}"
      URI.parse(URI.encode(url)).read
    rescue Exception => e
      
    end
  end

  def hash_json(json)
    JSON.parse(json)
  end

  def get_id
    @initial_hash["id"]
  end

  def get_name
    @initial_hash["name"]
  end

  def get_paging
    @initial_hash['paging']
  end

  def get_likes_count_for_post(post_id)
    likes_url = "#{@facebook_graph_url + @version}/#{post_id}/likes?access_token=#{@access_token}&summary=true"
    json = fetch_url(likes_url)
    hash = hash_json(json)
    hash['summary']['total_count']
  end

  def get_posts_with_comments_from_hash(hash)
    posts = []
    hash.each do |fb_post|
      post = Hash.new
      post['images'] = [fb_post['full_picture']]
      post['message'] = fb_post['message']
      post['time'] = fb_post['created_time']
      post['like_count'] = self.get_likes_count_for_post(fb_post['id'])
      post['share_count'] = fb_post['shares']['count'] if not fb_post['shares'].nil?
      post['source'] = "https://www.facebook.com/"+fb_post['id']
      post['comments'] = []
      fb_post['comments']['data'].each do |fb_comment|
        comment = Hash.new
        comment['like_count'] = fb_comment['like_count']
        comment['time'] = fb_comment['created_time']
        comment['message'] = fb_comment['message']
        comment['source'] = "https://www.facebook.com/"+fb_comment['id']
        post['comments'].push(comment)
      end
      posts.push(post)
    end
    posts
  end

  def get_ffb_post_from_fb_post(user,fb_post)
    user.posts.create(
      images: fb_post['images'],
      message: fb_post['message'],
      time: fb_post['time'],
      like_count: fb_post['like_count'],
      share_count: fb_post['share_count'],
      source: fb_post['source'],
      )
  end

  def get_ffb_comment_from_fb_comment(post,fb_comment)
    post.comments.create(
      like_count: fb_comment['like_count'],
      time: fb_comment['time'],
      message: fb_comment['message'],
      source: fb_comment['source'],
      user_id: post.user_id
      )
  end

  def save_posts_from_hash(user,hash)
    get_posts_with_comments_from_hash(hash).each do |fb_post|
      begin
        post = get_ffb_post_from_fb_post(user,fb_post)
        post.save
        @number_of_posts_remaining = @number_of_posts_remaining - 1
        @progress_bar.increment
        fb_post['comments'].each do |fb_comment|
          comment = get_ffb_comment_from_fb_comment(post,fb_comment)
          comment.save
        end
        break if @number_of_posts_remaining <= 0
      rescue Exception => e
        puts "Error: " + e.message + "\n"
        puts "Post: " + fb_post['message']
      end
    end
  end

  def save_posts_with_comments_from_facebook_page(user)
    save_posts_from_hash(user,@initial_hash['posts']['data'])
    if @number_of_posts_remaining > 0
      save_next_batches_of_posts(user)
    end
  end

  def save_next_batches_of_posts(user)
    while @number_of_posts_remaining > 0
      posts_batch = get_next_batch_of_posts
      break if posts_batch.empty?
      save_posts_from_hash(user,posts_batch)
    end
  end

  def get_next_batch_of_posts
    url = get_next_posts_url
    decoded_url = URI.decode(url) #Facebook provide already encoded URL
    json = fetch_url(decoded_url)
    @page_iterator = hash_json(json)
    @page_iterator['data']
  end

  def get_next_posts_url
    if @page_iterator == @initial_hash
      @initial_hash['posts']['paging']['next']
    else
      @page_iterator['paging']['next']
    end
  end

end