class Person < GameEntity

	attr_accessor :name, :health, :alive

	alias_method :alive?, :alive

	def marshal_dump
		super.merge({ health: @health, alive: @alive, inventory: @inventory })
	end

	def load_unsaved_data(data)
		super
		@on_death = data[:on_death]
		@words = data[:words] || "#@name has nothing to say right now."
	end

	def setup(data)
		super
		@health = data[:health] || 30 # please always set this, don't just use the default
		@alive = data[:alive] == nil ? true : data[:alive]
		@inventory = data[:inventory] || ObjectManager.new([])
	end

	def talk
		puts @words
	end

	def look
		puts @description
	end

	def die
		if @on_death
			@on_death.call(self)
		end
		@alive = false
		@delegate.current_scene.items += @inventory
	end

end
