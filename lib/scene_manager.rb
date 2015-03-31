class SceneManager

	attr_accessor :scenes

	def initialize(delegate)
		setup({ delegate: delegate })
	end

	def marshal_dump
		{ delegate: @delegate, scenes: @scenes }
	end

	def marshal_load(data)
		setup(data)
	end

	def setup(data)
		@delegate = data[:delegate]
		@scenes = data[:scenes] || {}
		setup_scenes
	end

	def setup_scenes
		@scenes[:start] ||= Scene.new({ delegate: @delegate,
				name: "Hetic Circus (this isn't staying here)" })
	end

	def [](id)
		@scenes[id]
	end

end