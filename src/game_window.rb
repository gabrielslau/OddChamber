class GameWindow < Chingu::Window
  include Sfx

  def initialize
    super(ScreenWidth, ScreenHeight)
    # transitional_game_state(Chingu::GameStates::FadeTo, {:speed => 9})
  end
  
  def setup
    $window.caption = "OddChamber: Perpetual Testing Initiative"

    # Background songs
    $musicMenu  = self.load_song(:main_menu)
    $musicGame = self.load_song(:gameplay_chamber01)
    $musicEnd   = self.load_song(:credits)

    # retrofy
    switch_game_state(Menu)
    # switch_game_state(Chamber01)
  end
end