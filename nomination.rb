class Nomination
	attr_accessor :nominee, :category, :year, :film, :character, :is_winner

	def initialize
		@nominee = nil
		@year = nil
		@category = nil
		@is_winner = nil
	end

	def assign_year(raw_year)
		@year = raw_year.gsub(/ \(....\)/, "").to_i
	end

	def ditch_year?
		@year.to_i < 1945
	end

	def ditch_film?
		film.to_i
	end

	def is_tech_or_honorary?
		nominee[0..2] == "To " 
	end

	def assign_film(raw_film)
		if raw_film && strip_character(raw_film)
			@character = strip_character(raw_film).to_s.gsub("{'","").gsub("'}","") 
			@film = raw_film.match(/.*{/).to_s.gsub(' {', '')
		else
			@character = nil
		end
	end

	def swap_nominee_and_film
		@film = nominee
		@nominee = ""
	end

	def is_eligible_category?
		["Actor -- Leading Role",
			"Actor -- Supporting Role",
			"Actress -- Leading Role",
			"Actress -- Supporting Role",
			"Directing"].include?(category)
	end

	def strip_character(raw_film)
		raw_film.match(/{'.*'}/)
	end
end