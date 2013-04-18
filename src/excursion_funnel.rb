#
# ExcursionFunnel: Tunel de luz com movimento horizontal automático
#
class ExcursionFunnel < GameObject
  traits :velocity, :collision_detection, :timer, :bounding_box
  
  attr_accessor :direction

  def setup
    @width = @height     = 64

    @animations          = {
      :backward => Animation.new(:file => ImageDir+"/structures/ExcursionFunnel_orange_64x64.png", :size => [@width, @height], :delay => 400),
      :forward  => Animation.new(:file => ImageDir+"/structures/ExcursionFunnel_blue_64x64.png",   :size => [@width, @height], :delay => 400)
    }

    @direction             = :forward
    @image                 = @animations[@direction].first
    self.mode              = :additive
    self.factor            = 1
    self.zorder            = 200
    # self.rotation_center = :middle
    @activated             = false
    cache_bounding_box

    update
  end

  def toggle_direction
    slef.toggle_status!
  end
  alias toggle_direction! toggle_direction
  
  def toggle_status
    @direction = if(@direction == :forward) then :backward else :forward end
  end
  alias toggle_status! toggle_status

  def update
    @image = @animations[@direction].next
    
    self.each_collision(Subject, WeightedCompanionCube) do |me, target|
      if(@direction == :forward) then 
        target.x += 2 
      else 
        target.x += -2 
      end
      
      target.y = me.y
    end
  end
end