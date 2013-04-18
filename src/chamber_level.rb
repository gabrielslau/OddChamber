#
# ChamberLevel: Características básicas e comuns de todas as chambers
#
class ChamberLevel < GameState
  traits :viewport, :timer
  
  attr :subject, :vital_apparatus_vent

  def initialize(options = {})
    super
    @width  = ScreenWidth * 2
    @height = ScreenHeigth
    self.viewport.game_area = [0, 0, @width, @height]    # dimensões do mapa
    load_game_objects

    self.input =  { 
      :escape => :exit, 
      :e      => :edit,
      :m      => Menu,
      :h      => :toggle_help,
      :p      => Pause
    }

    @help_bg = nil
    # @vital_apparatus_vent.drop
	@chegou_no_fim = false
  end

  def setup
    $musicIntro.play
    @parallax.camera_x = 0
  end
  
  def edit
    push_game_state(GameStates::Edit.new(:grid => [32,32], :classes => [Subject, HighEnergyPelletLauncher, VitalApparatusVent, Savepoint, Goo, ExcursionFunnel, BlockBlack, BlockGray, HeavyDutySuperCollidingSuperButton, SwitchButton, WeightedCompanionCube, Gate, Cake, Chamberlock, Saw]))
  end

  def pause_sfx
    $musicIntro.pause
    @announcer.pause
  end

  def resume_sfx
    $musicIntro.play if $musicIntro.paused?
    @announcer.play if @announcer.paused?
  end

  # Executa uma ação específica do mapa para quando o jogador morre
  # Caprichar mais nessa ação
  def handle_death
    # @vital_apparatus_vent.drop
  end

  def toggle_help
    
    if @help_bg.nil? then
      @color = Gosu::Color.new(0,0,0,0)
      @alpha = 0.1
      @help_bg = $window.draw_quad( 0,0,@color,
                          $window.width,0,@color,
                          $window.width,$window.height,@color,
                          0,$window.height,@color,1)
    else
      @help_bg = nil
    end
  end

  def update    
    super

    @subject.each_collision(EnergyPellet) do |player, evil_object|
      player.die
    end

    # para evitar que o personagem fique no limbo, ao sair da tela (o que não deveria acontecer ¬¬)
    if(@subject.x <= 0 or @subject.x > @width or @subject.y <= 0 or @subject.y > @height) then
      @subject.die
    end

    # @cube.die if(@cube.x > @width or @cube.y > @height)
      
    @subject.each_collision(Chamberlock) do |player, chamber|
      if not(@chegou_ao_fim) then
		@chegou_ao_fim = true
		  chamber.checkpoint
		  $musicIntro.stop
		  switch_game_state(Chamber02)
	  end
    end

    # @subject.each_collision(Cake) do |player, cake|
    #   cake.die
    #   $musicIntro.stop
    #   switch_game_state(Credits)
    # end
        
    self.viewport.center_around(@subject)

    @parallax.camera_x = self.viewport.x + 5
    @parallax.camera_y = self.viewport.y
    @parallax.update
  end
  def draw
    @parallax.draw
    @help_bg.draw if(defined?(@help_bg) and not(@help_bg.nil?))
    super    
  end
end