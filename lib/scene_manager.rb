class SceneManager

	attr_accessor :scenes

	def initialize(delegate)
		setup({ delegate: delegate })
	end

	def marshal_dump
		{ delegate: @delegate, scenes: @scenes, items: @items }
	end

	def marshal_load(data)
		setup(data)
	end

	def setup(data)
		@delegate = data[:delegate]
		@scenes = data[:scenes] || {}
		@items = data[:items] || {}
		setup_scenes
	end

	def setup_scenes

		# ITEMS:

		@items[:strawberry] ||= Item.new({ name: "strawberry",
			description: "ITZ UH STRAWBERRY", article: "a", alt_names: ["strawberry"] })

		# SCENES:

		@scenes[:start] ||= Scene.new({ delegate: @delegate,
			name: "Hetic Circus (this isn't staying here)",
			items: ObjectManager.new(
				[@items[:strawberry]]
			)})
		# this scene probaly won't stay
		@scenes[:backstage] ||= Scene.new({ delegate: @delegate,
			name: "Backstagftgefgefrgp||||bfgttr" })


		@scenes[:start].paths = { e: @scenes[:backstage] }
		@scenes[:backstage].paths = { w: @scenes[:start] }
	end

	def [](id)
		@scenes[id]
	end

end