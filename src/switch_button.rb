#
# SwitchButton, elemento de ativação. Usado para ativar mecanismos no jogo
#
class SwitchButton < GameObject
  include Sfx
  
  traits :bounding_box, :collision_detection
  attr_accessor :activated, :can_interact

  def setup
    @image        = Image[ImageDir+"/buttons/SwitchButton.png"]
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

    # tenta executar uma acao no objeto marcado
    if( @target.kind_of?(Array) ) then
      @target.each do |target|
        target.toggle_status! if defined?(target.toggle_status!)
      end
    else
      @target.toggle_status! if defined?(@target.toggle_status!)
    end

    # toggle status
    @activated = not(@activated)
  end
  alias toggle_status! toggle_status

  def update
    self.each_collision(Subject) do |me, subject|
      if $window.button_down?( subject.buttonAction ) and me.can_interact? then
        me.toggle_status!
      end
    end
  end
end