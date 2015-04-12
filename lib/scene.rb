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
			puts @name.cyan + "#{' :' + @key.to_s if $developer_mode}"
		end
	end

	def look
		puts @name.cyan + "#{' :' + @key.to_s if $developer_mode}"
		puts @description
		list_items
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
