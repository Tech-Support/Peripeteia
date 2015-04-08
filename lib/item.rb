class Item < GameEntity

	def load_unsaved_data(data)
		super
		@article = data[:article] || ""
	end

	def inspect
		puts @description
	end

	def name_with_article
		@article.empty? ? @name : "#@article #@name" 
	end

end
