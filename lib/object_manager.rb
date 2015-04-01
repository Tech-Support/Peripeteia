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
		@objects.delete(self[key])
	end

end
