class SavableObject

	attr_reader :delegate

	def initialize(opts = {})
		setup(opts)
	end

	def marshal_load(data)
		setup(data)
	end

	def marshal_dump
		{ updates: @updates, delegate: @delegate }
	end

	def setup(data)
		@delegate = data[:delegate]
		@updates = data[:updates] || []
	end

	def add_update(name, update)
		unless @updates.include?(name)
			update.call(self)
			@updates << name
		end
	end

end

class GameEntity < SavableObject

	attr_reader :alt_names

	def load_unsaved_data(data)
		@name = data[:name]
		@description = data[:description]
		if @alt_names = data[:alt_names]
			@alt_names << @name.downcase
		else
			@alt_names = [@name.downcase]
		end
	end

end
