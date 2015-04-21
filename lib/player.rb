class Player < SavableObject

	attr_accessor :inventory, :money

	def marshal_dump
		super.merge({ name: @name, health: @health, max_health: @max_health, money: @money, inventory: @inventory, weapon: @weapon })
	end

	def setup(data)
		super
		@name = data[:name] || "Ron"
		@inventory = data[:inventory] || ObjectManager.new([])
		@max_health = data[:max_health] || 20
		@health = data[:health] || @max_health
		@money = data[:money] || 30
		@weapon = data[:weapon]
	end

	def look_in_inventory
		if @inventory.empty?
			puts "You don't have anything in your inventory"
		else
			@inventory.each do |item|
				if item.is_a?(Weapon)
					puts "#{item.name_with_article}:"
					r = item.damage_range
					amount = r.min == r.max ? "#{r.min}" : "#{r.min}-#{r.max}"
					puts "  deals #{amount} damage"
				else
					puts item.name_with_article
				end
			end
		end
	end

	def give_item(item)
		@inventory << item
		puts "You got the #{item.name}!"
	end

	def print_info
		puts "Health: #@health/#@max_health"
		puts "Money: $#@money"
		puts "Equiped Weapon: #{@weapon ? @weapon.name : 'none'}"
	end

	def equip(weapon_name)
		if weapon = @inventory[weapon_name]
			if weapon.is_a?(Weapon)
				@weapon = weapon
				puts "#{@weapon.name} equiped!"
			else
				puts "You can't equip that."
			end
		else
			puts "You don't have that."
		end
	end

	def unequip_weapon
		@weapon = nil
	end

	def take_damage(amount)
		@health -= amount
		puts "-#{amount} health!".red
		die if @health <= 0
	end

	def heal(amount)
		@health += amount
		puts "+#{amount} health!"
	end

	def attack(enemy)
		@weapon ? @weapon.deal_damage(enemy) : punch(enemy)
	end

	def punch(enemy)
		enemy.take_damage(rand(2..4))
	end

	def die
		puts "you dead. (change this message...)"

		if (file = @delegate.save_file) && File.file?(file)
			File.delete(file)
		end

		exit
	end

end
