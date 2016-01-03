class Movie
	attr_accessor :title, :budget, :popularity, :vote_average, :vote_count, :release_date, :revenue, :runtime, :production_company_1, :production_company_2, :production_company_3, :imdb_id, :genre

	def initialize(movie)
		@title = nil
		@budget = movie.budget
		@imdb_id = movie.imdb_id
		@genre = movie.genres.first.name
		@popularity = movie.popularity
		@vote_average = movie.vote_average
		@vote_count = movie.vote_count
		@release_date = movie.release_date
		@revenue = movie.revenue
		@runtime = movie.runtime
		@production_company_1 = movie.production_companies[0].name if movie.production_companies[0]
		@production_company_2 = movie.production_companies[1].name if movie.production_companies[1]
		@production_company_3 = movie.production_companies[2].name if movie.production_companies[2]
	end
end