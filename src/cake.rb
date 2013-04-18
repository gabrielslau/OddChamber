#
# Cake, premiação do personagem
# 
# TODO: Colocar na tela a mensagem: Parabéns!....
#
class Cake < GameObject
  trait :bounding_box, :debug => false
  traits :collision_detection, :effect, :timer
  
  def self.solid
    all.select { |block| block.alpha == 255 }
  end

  def self.inside_viewport
    all.select { |block| block.game_state.viewport.inside?(block) }
  end

  def setup
    @image = Image[ImageDir+"/scenario/cake.png"]
    @color = Color.new(0xff808080)
    cache_bounding_box
  end

  def die
    Sound[SoundDir+"/sfx/collectable.wav"].play
    self.collidable = false # Stops further collisions in each_collsiion() etc.
    self.rotation_rate = 5
    self.scale_rate = 0.005
    self.fade_rate = -5
    after(2000) { destroy }
  end  
end