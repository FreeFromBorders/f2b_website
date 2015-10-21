require File.expand_path('../../../config/environment',__FILE__)
require_relative 'facebook_graph'
fb=FacebookGraph.new("humansofnewyork","CAACEdEose0cBALkoYibvWZAwzCMMit5WVAlXSR7xsQ7x1vVtinHmijibnXAjTMLsJdh9MWUVBhBo32sSbv8ZA0dZCOesj9CvKCtTiuPHqUf5yG3zBVkcWjoFr5IJ0iJf7iopoVhPXAOlmbXcPETTkK7Jhs38XSvIfBTMPZBYPljo7o9PC9wN6R88pMEwsZABEp8zk89a65KjhgpcmZBBQ2heCPF855zDQZD")
p Post.new(:message=>fb.get_posts_with_comments[0]['message'])