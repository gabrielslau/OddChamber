class Block < Chingu::GameObject
  trait :bounding_box, :debug => true
  traits :collision_detection

  attr_accessor :x, :y
  
  def self.solid
    all.select { |block| block.alpha == 255 }
  end

  def self.inside_viewport
    all.select { |block| block.game_state.viewport.inside?(block) }
  end

  def setup
    cache_bounding_box
  end
end