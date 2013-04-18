#
# Help Screen
#
class Help < Chingu::GameState
  def initialize(options = {})
    super
    $window.caption = "Help - " + $window.caption
    previous_game_state.pause_sfx
    
    # self.input = {
    #   [:h, :escape] => :close
    # }

    self.input = { 
      :h      => :close,
      :escape => :exit
    }

    @color = Gosu::Color.new(0xFFffffff)
    @font_name = "arial"
    @font_size = 20

    @help_text = @help_text_obj = []
    @help_text << "Controles de navegacao"
    @help_text << "."
    @help_text << "- Setas do teclado: esquerda e direita, para navegacao horizontal"
    @help_text << "- Espaco: acao de pulo vertical;"
    @help_text << "- Shift: aumenta a aceleracao do personagem;"
    @help_text << "- G: segura/solta um objeto (o cubo);"
    @help_text << "- P: Pausa/Retoma o jogo;"

    @help_bg   = TexPlay.create_image($window, $window.width-2, $window.height-2, :color => [0,0,0,0.9])
    
    @x         = $window.width / 3
    @y         = $window.height / 4
    @displayed = false
  end

  def close
    # destroy
    # @help_text_obj.each{ |text|  
    #   text.destroy!
    # }
    previous_game_state.resume_sfx
    pop_game_state(:setup => false)    # Return the previous game state, dont call setup()
  end
  
  def draw
    previous_game_state.draw    # Draw prev game state onto screen (in this case our level)
    super                       # Draw game objects in current game state, this includes Chingu::Texts
    
    @help_bg.draw 1, 1, ZOrder::UI
  end  
end