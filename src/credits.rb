#
# Credits: ultima tela do jogo
#
class Credits < GameState
  traits :viewport, :timer

  def initialize(options = {})
    super

    self.input =  { 
      :escape => :exit,
      :return => :main_menu
    }

    self.viewport.game_area = [0, 0, ScreenWidth, ScreenHeight]    # dimensões do mapa

    @parallax = Chingu::Parallax.new(:rotation_center => :top_left, :x => 0, :y => 0, :zorder => 0, :repeat_x => true, :repeat_y => true)
    @parallax << {:image => ImageDir+"/bg/GameState-end.jpg", :damping => 10, :repeat_x => true, :repeat_y => true}
  end

  def setup
    $musicEnd.play
    @parallax.camera_x = 0
  end
  def draw
    # fill_gradient(:from => @bg2, :to => @bg1)
    @parallax.draw
    super    
  end

  def main_menu
    # $musicEnd.stop
    switch_game_state(Menu)
  end
end