#
# EnergyPellet: bola de energia
#
class EnergyPellet < GameObject
  include Sfx
  traits :velocity, :collision_detection, :timer
  trait :bounding_circle, :scale => 0.7
  
  def setup
    @animation = Animation.new(:file => ImageDir+"/hazards/EnergyPellet.png", :size => [TileSize,TileSize], :delay => 20)
    @image     = @animation.first
    # self.mode = :additive
    self.factor          = 1
    self.zorder          = 200
    self.rotation_center = :center
    self.velocity_y      = 2.1 # controla o quanto o projétil irá se locomover
    after(2000) { self.destroy }
    
    @sound_portal_blue   = self.load_sfx(:portal_blue)
  end
  
  def update
    @image = @animation.next
    @angle += 2

    self.first_collision(Subject) do |me, target|
      @sound_portal_blue.play
      target.die!
    end
  end
end