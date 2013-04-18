#
# Chamberlock (Portal Level Chamber), "Transporta" o personagem para a próxima chamber
# 
# TODO: Colocar, na tela, a mensagem: Parabéns! blablabla....
#
class Chamberlock < GameObject
  include Sfx
  traits :bounding_box, :collision_detection, :effect, :timer

  def initialize( options = {} )
    super
    # @type = :in
    @type = if defined? options[:type] then options[:type] else :in end
  end

  def setup
    @width = @height = 64
    @type = :in
  
    @sprite = {
      :in  => Image[ImageDir+"/structures/Chamberlock-in.png"],
      :out => Image[ImageDir+"/structures/Chamberlock-out.png"]
    }
    @image = @sprite[@type]
    self.rotation_center = :bottom_center

    @sound_portal_orange = self.load_sfx(:portal_orange)
    @sound_collectable   = self.load_sfx(:collectable)

    cache_bounding_box
  end

  def update
    @image = @sprite[@type]
  end

  # faz barulho para dizer que foi ativado ¬¬
  def checkpoint
    @sound_portal_orange.play
  end
  alias checkpoint! checkpoint

  def die
    @sound_collectable.play
    self.collidable = false # Stops further collisions in each_collsiion() etc.
    self.rotation_rate = 5
    self.scale_rate = 0.005
    self.fade_rate = -5
    after(2000) { destroy }
  end
  alias die! die
end