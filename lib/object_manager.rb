class ObjectManager

	attr_accessor :objects

	include Enumerable

	def initialize(objects)
		@objects = objects # an array
	end

	def each(&block)
		@objects.each(&block)
	end

	def [](name)
		name.downcase!
		@objects.each do |obj|
			if obj.alt_names.include?(name)
				return obj
			end
		end
		return nil
	end

	def to_s
		@objects
	end

	def +(other)
		self.class.new(@objects + other.objects)
	end

	def <<(other)
		@objects << other
	end

	def delete(key)
		if key.is_a?(Symbol)
			@objects.delete(self[key])
		else
			@objects.delete(key)
		end
	end

	def empty
		@objects.empty?
	end
	
	alias_method :empty?, :empty

end
