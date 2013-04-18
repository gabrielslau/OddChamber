#
# BlockBlack
#
class BlockBlack < Chingu::GameObject
	trait :bounding_box, :debug => false
	trait :collision_detection
  	def setup
  		super
		@image = Image[ImageDir+"/structures/block-black.png"]
		cache_bounding_box
	end
end