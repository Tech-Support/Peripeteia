class Item < GameEntity

	attr_reader :name, :key, :cost

	def load_unsaved_data(data)
		super
		@article = data[:article] || ""
		@key = data[:key]
		@cost = data[:cost] || nil # the cost can be used to buy or sell
	end

	def look
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
		if @block
			@block.call(self)
		end
	end

end

class Weapon < Item

	attr_reader :damage_range

	def load_unsaved_data(data)
		super
		@damage_range = data[:damage]
	end

	def deal_damage(victim)
		victim.take_damage(rand(@damage_range))
	end

end
