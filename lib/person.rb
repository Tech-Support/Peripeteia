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
		@max_health = data[:max_health]
		@health ||= @max_health
		@damage_range = data[:damage_range]
	end

	def setup(data)
		super
		@health = data[:health]
		@alive = data[:alive] == nil ? true : data[:alive] # don't set this yourself
		@inventory = data[:inventory] || ObjectManager.new([])
	end

	def reset_health
		@health = @max_health
	end

	def talk
		puts @words
	end

	def look
		puts @description
	end

	def take_damage(amount)
		@health -= amount
		puts "-#{amount} health dealt to #@name!".red
		die if @health <= 0
	end

	def die
		puts "#@name died!"
		if @on_death
			@on_death.call(self)
		end
		@alive = false
		@delegate.current_scene.items += @inventory
	end

	def attack(enemy)
		enemy.take_damage(rand(@damage_range))
	end

end
