class SceneManager < SavableObject

	attr_accessor :scenes

	def initialize(delegate)
		super({ delegate: delegate })
	end

	def marshal_dump
		super.merge({ scenes: @scenes, items: @items })
	end

	def marshal_load(data)
		setup(data)
	end

	def setup(data)
		super
		@scenes = data[:scenes] || {}
		@items = data[:items] || {}
		setup_scenes
	end

	def setup_scenes

		# ITEMS:

		@items[:coconut] ||= Item.new({ delegate: @delegate })
		@items[:coconut].load_unsaved_data({ name: "coconut",
			description: "Hm, this coconut must have fallen off a tree.", article: "a"
		})

		# SCENES:

		@scenes[:below_deck] ||= Scene.new({ delegate: @delegate})
		@scenes[:below_deck].load_unsaved_data({ name: "Below Deck",
			description: "You wake up from a horrible nightmare.\nThe roar of the creaking boards and the waves crashing\nagainst the side of the hull is deafening. You hear\npeople rushing around on the deck overhead."
		}) 

		@scenes[:main_deck] ||= Scene.new({ delegate: @delegate})
		@scenes[:main_deck].load_unsaved_data({ name: "Main Deck",
			description: "Everyone is sprinting around doing various things\nin a effort to keeep the ship afloat. The Captain\nshouts at you, \"Dont just stand there, maggot! Fetch some\nline from the galley to tie off the life lines! GO!\""
		})

		@scenes[:shore] ||= Scene.new({ delegate: @delegate})
		@scenes[:shore].load_unsaved_data({ name: "Island Shore",
			# add some sort of "you wake up" before this
			description: "You are on the shore of a small, gloomy island.\nThe ocean is eerily calm, causing a thick silence\nto coat the shore. The beach continues east.\nThere is a large jungle to the north."
		})

		@scenes[:shore_east] ||= Scene.new({ delegate: @delegate })
		@scenes[:shore_east].load_unsaved_data({ name: "Eastern Island Shore",
			description: "The shore continues to stretch to the west."
		})

		@scenes[:jungle] ||= Scene.new({ delegate: @delegate,
			items: ObjectManager.new([
				@items[:coconut]
			])
		})
		@scenes[:jungle].load_unsaved_data({ name: "Jungle",
			# make this poetic
			description: "The trees are very tall here, and there's not much\nlight coming through. The beach is to the south."
		})

		@scenes[:shore].paths = { n: @scenes[:jungle], e: @scenes[:shore_east] }
		@scenes[:shore_east].paths = { w: @scenes[:shore] }
		@scenes[:jungle].paths = { s: @scenes[:shore] }
	end

	def [](id)
		@scenes[id]
	end

end