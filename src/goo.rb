#
# Goo: Chão ácido que destroi tudo que entra em contato com ele
#
class Goo < GameObject
  include Sfx
  traits :collision_detection, :bounding_box
  
  def setup
    @width                 = @height = 32
    @image                 = Image[ImageDir+"/hazards/goo-acid_32x32.png"]
    self.factor            = 1
    self.zorder            = 100
    # self.rotation_center = :middle
    @times_played          = 0
    
    @sound_portal_blue     = self.load_sfx(:portal_blue)

    cache_bounding_box
    update
  end
  
  def update
    # se houver outros objetos, é só incluir na lista abaixo
    self.each_collision(Subject, WeightedCompanionCube) do |me, target|
      if @times_played == 0 then
        @sound_portal_blue.play
        @times_played += 1
      end
      target.die!
    end

    @times_played = 0
  end
end