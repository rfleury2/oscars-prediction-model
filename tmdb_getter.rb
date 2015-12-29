require 'themoviedb-api'
require 'csv'

class TmdbGetter
	attr_reader :nomination

	def initialize(nomination)
		@api_key = Tmdb::Api.key("85bcdfa4777db2be679ac2c7b98da057")
		@nomination = nomination
		load_mapper
		puts movie_call

	end

	def movie_call
		movie_info = Tmdb::Search.movie('terminator').results.first
	end

	def load_mapper
	end

	def populate_mapper
	end
end
