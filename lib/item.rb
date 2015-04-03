class Item

	attr_reader :alt_names

	def initialize(opts)
		setup(opts)
	end

	def marshal_dump
		{ article: @article, name: @name, description: @description, alt_names: @alt_names }
	end

	def marshal_load(data)
		setup(data)
	end

	def setup(data)
		@name = data[:name]
		@description = data[:description]
		@alt_names = data[:alt_names]
		@article = data[:article] || ""
	end

	def inspect
		puts @description
	end

	def name_with_article
		"#@article #@name"
	end

end