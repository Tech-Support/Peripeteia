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

		@items[:strawberry] ||= Item.new({ delegate: @delegate })
		@items[:strawberry].load_unsaved_data({ name: "strawberry",
			description: "ITZ UH STRAWBERRY", article: "a"
		})

		@items[:peach] ||= Item.new({ delegate: @delegate })
		@items[:peach].load_unsaved_data({ name: "peach",
			description: "A lonely, delicious peach", article: "a"
		})

		# SCENES:

		@scenes[:start] ||= Scene.new({ delegate: @delegate,
			items: ObjectManager.new(
				[@items[:strawberry]]
			)
		})
		@scenes[:start].load_unsaved_data({ name: "Island shore",
			description: "You are on the shore of a small, gloomy island."
		})

		# @scenes[:start].paths = { e: @scenes[:backstage] }
	end

	def [](id)
		@scenes[id]
	end

end