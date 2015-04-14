class Scene < GameEntity

	attr_accessor :paths, :items, :key

	def marshal_dump
		super.merge({ items: @items })
	end

	def setup(data)
		super
		# @visited = data[:visited] || false
		@items = data[:items] || ObjectManager.new([])
	end

	def load_unsaved_data(data)
		super
		@paths = {}
		@visited = false
		@key = data[:key]
	end

	def [](direction)
		@paths[direction]
	end

	def enter
		if !@visited
			look
			@visited = true
		else
			print_name
		end
	end

	def look
		print_name
		puts @description
		list_items
	end

	def print_name
		puts @name.cyan + "#{' :' + @key.to_s if $developer_mode}"
	end

	def list_items
		unless @items.empty?
			puts "Items here:".magenta
			@items.each do |item|
				puts item.name_with_article
			end
		end
	end

end

class Shop < Scene

	def marshal_dump
		super.merge({ inventory: @inventory })
	end

	def setup(data)
		super
		@inventory = data[:inventory] || ObjectManager.new([])
	end

	def buy(item_name)
		if item = @inventory[item_name]
			if @delegate.player.money - item.cost >= 0
				@delegate.player.give_item(item)
				@inventory.delete(item)
				@delegate.player.money -= item.cost
			end
		else
			puts "That item isn't here."
		end
	end

	def look
		super
		print_inventory
	end

	def print_inventory
		unless @inventory.empty?
			puts "Items avalible to buy:".magenta
			@inventory.each do |item|
				puts "#{item.name_with_article} - $#{item.cost}"
			end
		end
	end

end
