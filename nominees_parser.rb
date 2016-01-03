require_relative 'tmdb_getter'
require_relative 'nomination'
require 'byebug'

require 'csv'
require 'nokogiri'

class NomineesParser
	def initialize
		@nominations = []
		parse_best_picture
		parse_best_actor
		parse_best_supporting_actor
		parse_best_actress
		parse_best_supporting_actress
		parse_best_director

		generate_csv
	end

	def parse_best_picture
		doc = Nokogiri::HTML(File.open("raw_data/best_picture_winners_wikipedia.html"))
		doc.xpath("//table").each do |table|
			year = table.xpath("caption/big/a").text 
			winner = table.xpath("tbody/tr/td/i/a").each_with_index do |movie_name, index|
				nomination = Nomination.new
				nomination.assign_year(year)
				next if nomination.ditch_year?
				nomination.category = "Best Picture"
				nomination.film = movie_name.text
				nomination.nominee = movie_name.text
				if index == 0	
					nomination.is_winner = true
				else 
					nomination.is_winner = false
				end
				@nominations << nomination
			end
		end
	end

	def parse_best_actor
		# https://en.wikipedia.org/wiki/Academy_Award_for_Best_Picture#Winners_and_nominees
		CSV.foreach("raw_data/best_actor.csv") do |year, nominee, film, role|
			nomination = Nomination.new
			nomination.assign_year(year)
			next if nomination.ditch_year?
			nomination.film = film
			nomination.assign_nominee(nominee)
			nomination.role = role
			nomination.category = "Actor -- Leading Role"
			@nominations << nomination
		end
	end

	def parse_best_supporting_actor
		CSV.foreach("raw_data/best_support_actor.csv") do |year, nominee, film, role|
			nomination = Nomination.new
			nomination.assign_year(year)
			next if nomination.ditch_year?
			nomination.film = film
			nomination.assign_nominee(nominee)
			nomination.role = role
			nomination.category = "Actor -- Supporting Role"
			@nominations << nomination
		end
	end

	def parse_best_actress
		CSV.foreach("raw_data/best_actress.csv") do |year, nominee, film, role|
			nomination = Nomination.new
			nomination.assign_year(year)
			next if nomination.ditch_year?
			nomination.film = film
			nomination.assign_nominee(nominee)
			nomination.role = role
			nomination.category = "Actress -- Leading Role"
			@nominations << nomination
		end
	end

	def parse_best_supporting_actress
		CSV.foreach("raw_data/best_support_actress.csv") do |year, nominee, film, role|
			nomination = Nomination.new
			nomination.assign_year(year)
			next if nomination.ditch_year?
			nomination.film = film
			nomination.assign_nominee(nominee)
			nomination.role = role
			nomination.category = "Actress -- Supporting Role"
			@nominations << nomination
		end
	end

	def parse_best_director
		CSV.foreach("raw_data/best_director.csv") do |year, nominee, film|
			nomination = Nomination.new
			nomination.assign_year(year)
			next if nomination.ditch_year?
			nomination.film = film
			nomination.assign_nominee(nominee)
			nomination.category = "Directing"
			@nominations << nomination
		end
	end

	def generate_csv
		CSV.open("nominees_table.csv", "wb") do |csv|
			csv << ['year', 'category', 'film', 'nominee', 'character_name', 'is_winner']
			@nominations.each do |nomination|
		  	csv << [
					nomination.year,
					nomination.category,
					nomination.film,
					nomination.nominee,
					nomination.role,
					nomination.is_winner
		  	]
			end
		end
	end

	def find_movie_information(nomination)
		# TmdbGetter.new(nomination)
	end
end

NomineesParser.new