require_relative 'facebook_graph'
fb=FacebookGraph.new("humansofnewyork","CAACEdEose0cBAMihA25C7PlxmMlmE04n9eI7RdKXTxz4Ys8VYbjgaTnYzv1kNRmcJAQw5QBgc7mZAJfCn8BBF65DCBDBj9ZBTNUA95ZAepQkefJ2ee68FR7GbvnVaYnnvnmb67g1jEqbYG3531Ap1PICq98xKDOzMA7tznxiDj7jtEMlNYzZAl1c8SAYxqnKonRkfsFeeZAyMme4olt9F")

print fb.savePostsToUser()