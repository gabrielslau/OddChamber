#
# Gate, libera o acesso a algumas partes do mapa depois de ativar o botão
#
class Gate < GameObject
  include Sfx
  trait :bounding_box, :debug => false
  traits :collision_detection, :timer, :effect

  def setup
    @image               = Image[ImageDir+"/structures/gate.png"]
    @color               = Color.new(0xff808080)
    self.rotation_center = :top_center
    self.collidable      = false
    
    @sound_die  = self.load_sfx(:door_open)
    # @sound_die  = self.load_sfx(:explosion)

    cache_bounding_box
  end

  def die
    # 
    # TODO: fazer animação mais estilosa
    #
    @sound_die.play
    self.collidable = false # Stops further collisions in each_collsiion() etc.
    self.scale_rate = 0.05
    self.fade_rate = -5
    after(2000) { destroy }
  end
  alias die! die

  # Metodo em comum entre todos os objetos "interagíveis" do jogo
  # Serve como atalho para o seu método de ação específico
  def toggle_status
    self.die!
  end
  alias toggle_status! toggle_status
end
