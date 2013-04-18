#
# Savepoint
#
class Savepoint < GameObject
  traits :collision_detection, :timer, :bounding_box

  attr_accessor :active
  
  def initialize( options = {} )
    super
    @type = :idle
    @type = if defined? options[:type] then options[:type] else :idle end

    @active = false
  end

  def setup  
    super  
    @sprite = {
      :idle   => Image[ImageDir+"/structures/Aperture_Savepoint-idle.png"],
      :active => Image[ImageDir+"/structures/Aperture_Savepoint-active.png"]
    }

    @saved_x = @saved_y = 0
    @active  = false
    @image   = @sprite[:idle]

    # self.rotation_center = :bottom_center
    cache_bounding_box
    update
  end

  def update

    @image = if @active then @sprite[:active] else @sprite[:idle] end

    self.each_collision(Subject) do |me, target|
      target.saved_x, @saved_x = self.x if(target.saved_x != @saved_x)
      target.saved_y, @saved_y = self.y if(target.saved_y != @saved_y)

      if(target.saved_x != @saved_x or target.saved_y != @saved_y)
        # desativa todos os outros savepoints
        Savepoint.each do |token|
          token.active = false
        end
        # ativa o atual
        me.active = true
      end
    end
  end
end