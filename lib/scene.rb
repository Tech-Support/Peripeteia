class Scene < GameEntity

	attr_accessor :paths, :items, :key, :people

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
		@people = data[:people] || ObjectManager.new([])
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

	def leave
		@people.each do |person|
			person.reset_health
		end
	end

	def look
		print_name
		puts @description
		list_items
		list_people
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

	def living_people
		happnin_cats = @people.select { |person| person.alive? }
		ObjectManager.new(happnin_cats)
	end

	def list_people
		unless living_people.empty?
			puts "People here".magenta
			living_people.each do |person|
				puts person.name
			end
		end
	end

end

class Shop < Scene

	def marshal_dump
		super.merge({ inventory: @inventory })
	end

	def load_unsaved_data(data)
		super
		@owner = data[:owner]
		@people << @owner
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
			else
				puts "You can't afford that, get a job."
			end
		else
			puts "That item isn't here."
		end
	end

	def steal(item_name)
		if @owner && @owner.alive?
			puts "No stealing in my shop!"
			@owner.attack(@delegate.player)
		else
			if item = @inventory[item_name]
				@delegate.player.give_item(item)
				@inventory.delete(item)
			else
				puts "That item isn't here."
			end
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
