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
			description: "Hm, this coconut must have fallen of a tree.", article: "a"
		})

		# SCENES:

		@scenes[:shore] ||= Scene.new({ delegate: @delegate})
		@scenes[:shore].load_unsaved_data({ name: "Island Shore",
			description: "You are on the shore of a small, gloomy island.\nThe shore continues east. There is a mysterious jungle north."
		})

		@scenes[:shore_east] ||= Scene.new({ delegate: @delegate })
		@scenes[:shore_east].load_unsaved_data({ name: "Island Shore",
			description: "The shore continues west."
		})

		@scenes[:jungle] ||= Scene.new({ delegate: @delegate,
			items: ObjectManager.new([
				@items[:coconut]
			])
		})
		@scenes[:jungle].load_unsaved_data({ name: "Jungle",
			# make this poetic
			description: "The trees are very tall here, theres not much\nlight coming through. The beach is south."
		})

		@scenes[:shore].paths = { n: @scenes[:jungle], e: @scenes[:shore_east] }
		@scenes[:shore_east].paths = { w: @scenes[:shore] }
		@scenes[:jungle].paths = { s: @scenes[:shore] }
	end

	def [](id)
		@scenes[id]
	end

end