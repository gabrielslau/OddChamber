#
# Menu: seleciona a operacao do jogo: New Game, Exit
#
class Menu < GameState
  traits :viewport, :timer

  def initialize(options = {})
    super

    self.input =  { 
      :escape  => :exit,
      :return  => :new_game
    }

    # @color = Gosu::Color.new(0,0,0,0)
    self.viewport.game_area = [0, 0, ScreenWidth, ScreenHeight]    # dimensões do mapa

    @parallax = Chingu::Parallax.new(:rotation_center => :top_left, :x => 0, :y => 0, :zorder => 0, :repeat_x => true, :repeat_y => true)
    @parallax << {:image => ImageDir+"/bg/GameState-intro.jpg", :damping => 1, :repeat_x => true, :repeat_y => true}

    @title = Chingu::Text.create(:text => "Press 'ENTER' to start the game", :x=>250, :y=>400, :size=>25, font: FontSrc)
    Chingu::Text.create(:text => "Press 'ESC' to give up", :x=>250, :y=>440, :size=>25, font: FontSrc)
    
    Sound[SoundDir+'/gamespeak/GLaDOS/GLaDOS_00_part1_entry-1 - Hello and, again, welcome to the Aperture Science computer-aided enrichment center.wav'].play
  end


  def setup
    # $musicMenu.play
    @parallax.camera_x = 0
  end
  def draw
    @parallax.draw
    super    
  end

  def new_game
    # $musicMenu.pause
    switch_game_state(Chamber01)
  end
end