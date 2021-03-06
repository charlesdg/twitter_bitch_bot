class Twitterapp < ActiveRecord::Base
	
	require 'twitter'

	def self.twitter_client
		Twitter::REST::Client.new do |config|
			config.consumer_key        = 'ntJjYSJ26B60j0f19KubQDVYf'
			config.consumer_secret     = '2MJ3uUfomyLOk0pnwOSXjFz4AxDZjAGMbQmbvnL0aMJiN3j3Ab'
			config.oauth_token        = '2756462101-3eJsWGUu5mCrSl8As6gNrgZIJ1frPdLRJMnSWRJ'
			config.oauth_token_secret = 'aO8VU5YYxD7MkcDgAZc8rj5sCozow34FBrn7KXLHh5mcf'
		end
	end

	def self.friends(twitter_username)
		self.twitter_client.friends(twitter_username, {:cursor => -1, :count => 5000} )
	end

	def self.fetch_all_followers(twitter_username, max_attempts = 100)
		# in theory, one failed attempt will occur every 15 minutes, so this could be long-running
		# with a long list of friends
		num_attempts = 0
		running_count = 0
		cursor = -1
		client = self.twitter_client
		while (cursor != 0) do
			begin
				num_attempts += 1
				# 200 is max, see https://dev.twitter.com/docs/api/1.1/get/friends/list
				friends = client.followers(twitter_username, {:cursor => cursor, :count => 5000} )
				friends.each do |f|
					running_count += 1
					@time_last_tweet = nil
					@last_tweet = client.user_timeline(f.id).first
					@time_last_tweet = @last_tweet.created_at if @last_tweet
					Follower.create(f.statuses_count, f.friends_count, f.followers_count, f.screen_name, f.id, f.location, f.lang, @time_last_tweet)
				end
				puts "#{running_count} done"
				#cursor = friends.next_cursor
				#break if cursor == 0
			rescue Twitter::Error::TooManyRequests => error
				if num_attempts <= max_attempts
					#cursor = friends.next_cursor if friends && friends.next_cursor
					puts "#{running_count} done from rescue block..."
					puts "Hit rate limit, sleeping for #{error.rate_limit.reset_in}..."
					sleep error.rate_limit.reset_in
					retry
				else
					raise
				end
			rescue
				
			end
		end
	end

	def self.retweet(tweet)
		self.twitter_client.retweet!(tweet)
	end

	def self.favorite(tweet)
		self.twitter_client.favorite!(tweet)
	end

	def self.follow(twitter_username)
		self.twitter_client.follow!(twitter_username)
	end

	def self.unfollow(twitter_username)
		self.twitter_client.unfollow(twitter_username)
	end

	def self.search_keyword(keyword, occurence)
		@influencers = Hash.new
		client = self.twitter_client
		client.search(keyword, :result_type => "recent").take(occurence).collect do |tweet|
			#puts "#{tweet.user.screen_name}: #{tweet.text}"
			if @influencers.include? tweet.user.id
				@influencers[tweet.user.id] += 1
				#p @@client.user_timeline(tweet.user.id).first.created_at
			else
				@influencers[tweet.user.id] = 1
				@influencer = Influencer.create(tweet.user.statuses_count, tweet.user.friends_count, tweet.user.followers_count, tweet.user.screen_name, tweet.user.id, tweet.user.location)
				Topic.create(@influencer, keyword)
			end
		end
		@influencers
	end

end