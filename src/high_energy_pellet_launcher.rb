#
# HighEnergyPelletLauncher: Lançador de bolas de energia. Destroi o jogador.
# TODO: usar como mecanismo de ativação
#       fazer a bola de energia ricochetar nos tiles e navegar por uma longa distância
#
class HighEnergyPelletLauncher < GameObject
  traits :bounding_box, :timer
  def setup
    @image = Image[ImageDir+"/hazards/HighEnergyPelletLauncher.png"]
    every(3000)  { fire }
    cache_bounding_box
  end
  
  def fire
    # return if game_state.viewport.outside?(self.bb.centerx, self.bb.bottom)
    EnergyPellet.create(:x => self.bb.centerx - rand(10), :y => self.bb.bottom - rand(20))
  end
end