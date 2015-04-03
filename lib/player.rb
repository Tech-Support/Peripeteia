class Player

	attr_accessor :inventory

	def initialize(opts)
		setup(opts)
	end

	def marshal_dump
		{ delegate: @delegate, name: @name, health: @health, inventory: @inventory }
	end

	def marshal_load(data)
		setup(data)
	end

	def setup(data)
		@delegate = data[:delegate]
		@name = data[:name] || "Ron"
		@inventory = data[:inventory] || ObjectManager.new([])
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

end
