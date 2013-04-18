#
# Chamber01: A primeira fase do jogo
#
class Chamber01 < GameState
  traits :viewport, :timer
  attr :subject, :vital_apparatus_vent


  def initialize(options = {})
    super

    @width  = ScreenWidth
    @height = ScreenHeigth
    self.viewport.game_area = [0, 0, @width, @height]    # dimensões do mapa
    load_game_objects

    self.input =  { 
      :escape => :exit, 
      :e      => :edit,
      :n      => :troca
    }
    
    @subject = Subject.create(:x => 92, :y => 50)

    @width_block = $window.width - 200
    @zorder_bg = 901
  end

  def edit
    push_game_state(GameStates::Edit.new(:grid => [32,32], :classes => [Subject, HighEnergyPelletLauncher, VitalApparatusVent, Savepoint, Goo, ExcursionFunnel, BlockBlack, BlockGray, HeavyDutySuperCollidingSuperButton, SwitchButton, WeightedCompanionCube, Gate, Cake, Chamberlock]), :finalize => false)
  end

  def troca
    push_game_state(Chamber02)
  end

  def update    
    super
    # self.viewport.center_around(@subject)
    
    # para evitar que o personagem fique no limbo, ao sair da tela (o que não deveria acontecer ¬¬)
    # if(@subject.x <= 0 or @subject.x > @width or @subject.y <= 0 or @subject.y > @height) then
    #   @subject.die
    # end
    
    # Avança para a próxima fase
    @subject.each_collision(Chamberlock) do |player, chamber|

      switch_game_state(Chamber02)
      # switch_game_state(Chamber02, :setup => false)
    end
  end

  def finalize
    self.game_objects.destroy_all
  end

  def draw
    pos_y = $window.height - 50
    pos_x = ($window.width / 2) - (@width_block / 2)
    height_block = 50
    super    
  end
end