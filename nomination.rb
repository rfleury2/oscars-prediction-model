class Nomination
	attr_accessor :nominee, :category, :year, :film, :is_winner, :role

	def initialize
		@role = nil
		@nominee = nil
		@year = nil
		@category = nil
		@is_winner = nil
	end

	def assign_year(raw_year)
		@year = raw_year.gsub(/ \(....\)/, "").to_i
	end

	def ditch_year?
		@year < 1945 || @year > 2015
	end

	def assign_nominee(nominee_name)
		@is_winner = nominee_name.include?("Award winner")
		@nominee = nominee_name.gsub(" Award winner", "").gsub("Award winner", "")
	end
end