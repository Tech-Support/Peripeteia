class Item < GameEntity

	def load_unsaved_data(data)
		super
		@article = data[:article] || ""
	end

	def inspect
		puts @description
	end

	def name_with_article
		@article.empty? ? @name : "#@article #@name" 
	end

end

class Rope < Item

	def tie_in_scene(scene)
		case scene
		when @delegate.scene_manager[:west_deck]
			@delegate.player.inventory.objects.delete(self)
			@delegate.teleport(:shore)
		else
			puts "There is nothing to tie a rope to here"
		end
	end

end
