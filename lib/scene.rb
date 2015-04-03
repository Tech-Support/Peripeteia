class Scene

	attr_accessor :paths, :items

	def initialize(opts)
		# opts must be a hash that includes the following keys:
		# :delegate
		# :name
		setup(opts)
	end

	def marshal_dump
		{ delegate: @delegate, name: @name, visited: @visited, items: @items }
	end

	def marshal_load(data)
		setup(data)
	end

	def setup(data)
		# @paths is intentionaly not saved
		@paths = {}

		@delegate = data[:delegate]
		@name = data[:name]
		@visited = data[:visited] || false
		@items = data[:items] || ObjectManager.new([])
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
		# puts @description
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

end