#
# BlockGray
#
class BlockGray < Chingu::GameObject
	trait :bounding_box, :debug => false
	traits :collision_detection
	attr_accessor :x, :y
  	def setup
		@image = Image[ImageDir+"/structures/block-gray.png"]
		cache_bounding_box
	end
end