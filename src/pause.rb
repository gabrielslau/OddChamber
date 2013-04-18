#
# Pause Screen
#
class Pause < Chingu::GameState
  def initialize(options = {})
    super
    @title = Chingu::Text.create(:text=>"PAUSED (press 'p' to un-pause)", :x=>100, :y=>200, :size=>30, :color => Color.new(0xFF00FF00))
    self.input = { 
      :p      => :un_pause,
      :escape => :exit
    }

    previous_game_state.pause_sfx
  end

  def un_pause
    pop_game_state(:setup => false)    # Return the previous game state, dont call setup()
  end
  
  def draw
    previous_game_state.draw    # Draw prev game state onto screen (in this case our level)
    super                       # Draw game objects in current game state, this includes Chingu::Texts
  end  
end