class Player

	def initialize(opts)
		setup(opts)
	end

	def marshal_dump
		{ delegate: @delegate, name: @name, health: @health }
	end

	def marshal_load(data)
		setup(data)
	end

	def setup(data)
		@delegate = data[:delegate]
		@name = data[:name] || "Ron"
	end

end
