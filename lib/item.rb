class Item < GameEntity

	attr_reader :name, :key

	def load_unsaved_data(data)
		super
		@article = data[:article] || ""
		@key = data[:key]
	end

	def inspect
		puts @description
	end

	def name_with_article
		@article.empty? ? @name : "#@article #@name" 
	end

end

class Rope < Item

	def load_unsaved_data(data)
		super
		@block = data[:block]
	end

	def tie
		@block.call(self)
	end

end
