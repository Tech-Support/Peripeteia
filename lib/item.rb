class Item

	attr_reader :alt_names

	def initialize(opts)
		setup(opts)
	end

	def marshal_dump
		{ name: @name, description: @description, alt_names: @alt_names }
	end

	def marshal_load(data)
		setup(data)
	end

	def setup(data)
		@name = data[:name]
		@description = data[:description]
		@alt_names = data[:alt_names]
	end

	def inspect
		puts @description
	end

end