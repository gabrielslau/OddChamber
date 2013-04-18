#
# HeavyDutySuper_CollidingSuperButton, elemento de ativação. Usado para ativar mecanismos no jogo
#
class HeavyDutySuperCollidingSuperButton < GameObject
  include Sfx

  traits :bounding_box, :collision_detection
  attr_accessor :activated, :can_interact

  def setup
    @image        = Image[ImageDir+"/buttons/HeavyDutySuper_CollidingSuperButton.png"]
    @activated    = false
    @can_interact = true
    @target       = nil # Elemento que será ativado pelo botão

    self.rotation_center = :bottom_center

    cache_bounding_box
  end

  def setTarget( target = nil )
    @target = target unless target.nil?
  end

  def can_interact?
    @can_interact
  end

  def toggle_status
    if( @activated ) then
      self.load_sfx(:button_negative).play
    else
      self.load_sfx(:button_positive).play
    end

    @target.toggle_status! if defined?(@target.toggle_status!)
  end
  alias toggle_status! toggle_status

  def update
    self.each_collision(WeightedCompanionCube) do |me, cube|
      if not @activated and not(cube.being_dragged) then
        toggle_status!
        @activated        = true
        cube.can_interact = false # impede que o cubo seta retirado do botão
      end
    end
  end
end