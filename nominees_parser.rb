require_relative 'tmdb_getter'
require_relative 'nomination'

require 'csv'
require 'nokogiri'

class NomineesParser
	def initialize
		@nominations = []
		parse_nominations
		parse_best_picture
		generate_csv
	end

	def parse_best_picture
		# https://en.wikipedia.org/wiki/Academy_Award_for_Best_Picture#Winners_and_nominees
		doc = Nokogiri::HTML(File.open("best_picture_winners_wikipedia.html"))
		doc.xpath("//table").each do |table|
			year = table.xpath("caption/big/a").text 
			winner = table.xpath("tbody/tr/td/i/a").each_with_index do |movie_name, index|
				nomination = Nomination.new
				nomination.assign_year(year)
				nomination.category = "Best Picture"
				nomination.film = movie_name.text
				if index == 0	
					nomination.is_winner = true
				else 
					nomination.is_winner = false
				end
				@nominations << nomination
			end
		end
	end

	def parse_nominations
		CSV.foreach("academy_awards_1945_2010.csv",  headers: true) do |nom|

			nomination = Nomination.new

			nomination.nominee = nom[2]
			next if nomination.is_tech_or_honorary?
			

			nomination.assign_year(nom[0])
			nomination.category = nom[1]
			next unless nomination.is_eligible_category?
			nomination.swap_nominee_and_film if nomination.category == "Directing"

			nomination.assign_film(nom[3])
			nomination.is_winner = nom[-1] 
			# nomination.is_winner = nom.last if nomination.category == "Best Picture"
			# find_age(nominee)
			find_movie_information(nomination)

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
					nomination.character,
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