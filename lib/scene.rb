class Scene

	def initialize(opts)
		# opts must be a hash that includes the following keys:
		# :delegate
		# :name
		setup(opts)
	end

	def marshal_dump
		{ delegate: @delegate, name: @name }
	end

	def marshal_load(data)
		setup(data)
	end

	def setup(data)
		@delegate = data[:delegate]
		@name = data[:name]
	end

	def look
		puts @name
	end

end