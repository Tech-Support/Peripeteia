class Scene < GameEntity

	attr_accessor :paths, :items

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
	end

	def [](direction)
		@paths[direction]
	end

	def enter
		if !@visited
			look
			@visited = true
		else
			puts @name
		end
	end

	def look
		puts @name
		puts @description
		list_items
	end

	def list_items
		unless @items.empty?
			puts "Items here:"
			@items.each do |item|
				puts item.name_with_article
			end
		end
	end

	def remove_item(item)
		@items.objects.delete(item)
	end

end