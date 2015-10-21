class PostsController < ApplicationController

	def index
		if user_signed_in?
			@temp="testin"
		end	
		
	end
end
