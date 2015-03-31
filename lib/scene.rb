class Scene

	attr_accessor :paths

	def initialize(opts)
		# opts must be a hash that includes the following keys:
		# :delegate
		# :name
		setup(opts)
	end

	def marshal_dump
		{ delegate: @delegate, name: @name, visited: @visited }
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
	end

end