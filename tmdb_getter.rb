require 'themoviedb-api'
require 'csv'
require_relative 'movie'

class TmdbGetter
	attr_reader :nomination

	def initialize
		@api_key = Tmdb::Api.key("85bcdfa4777db2be679ac2c7b98da057")
		@nomination = nomination
		@movies = []
		get_movie_names
		get_movies
		generate_csv
	end

	def get_movie_names
		@movie_names = []
		CSV.foreach("raw_data/movies_list.csv") do |movie_name|
			@movie_names << movie_name.first
		end
	end

	def get_movies
		@movie_names.each do |movie_name|
			puts movie_name
			movie_id = Tmdb::Search.movie(movie_name).results.first.id
			movie_info = Tmdb::Movie.detail(movie_id)
			movie = Movie.new(movie_info)
			movie.title = movie_name
			@movies << movie
		end
	end

	def generate_csv
		CSV.open("tmdb_movie_db_movie_info.csv", "wb") do |csv|
			csv << ["title", "budget", "popularity", "vote_average", "vote_count", "release_date", "revenue", "runtime", "production_company_1", "production_company_2", "production_company_3", "imdb_id", "genre"]
			@movies.each do |movie|
		  	csv << [
		  		movie.title,
					movie.budget,
					movie.popularity,
					movie.vote_average,
					movie.vote_count,
					movie.release_date,
					movie.revenue,
					movie.runtime,
					movie.production_company_1,
					movie.production_company_2,
					movie.production_company_3,
					movie.imdb_id,
					movie.genre
		  	]
			end
		end
	end
end

TmdbGetter.new