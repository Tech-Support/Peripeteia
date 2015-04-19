class Item < GameEntity

	attr_reader :name, :key, :cost

	def load_unsaved_data(data)
		super
		@article = data[:article] || ""
		@key = data[:key]
		@cost = data[:cost] || nil # the cost can be used to buy or sell
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
		@block = data[:block] || (-> (x) {})
	end

	def tie
		@block.call(self)
	end

end
