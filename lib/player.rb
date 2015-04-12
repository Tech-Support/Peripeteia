class Player < SavableObject

	attr_accessor :inventory

	def marshal_dump
		super.merge({ name: @name, health: @health, max_health: @max_health, inventory: @inventory })
	end

	def setup(data)
		super
		@name = data[:name] || "Ron"
		@inventory = data[:inventory] || ObjectManager.new([])
		@max_health = data[:max_health] || 20
		@health = data[:health] || @max_health
	end

	def look_in_inventory
		if @inventory.empty?
			puts "You don't have anything in your inventory"
		else
			@inventory.each do |item|
				puts item.name_with_article
			end
		end
	end

	def give_item(item)
		@inventory << item
		puts "You got the #{item.name}!"
	end

	def print_info
		puts "Health: #@health/#@max_health"
	end

end
