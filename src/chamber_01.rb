#
# Chamber01: A primeira fase do jogo
#
class Chamber01 < GameState
  traits :viewport, :timer
  attr :subject, :vital_apparatus_vent

  def initialize(options = {})
    super

    self.input =  { 
      :escape => :exit, 
      :e      => :edit,
      :m      => Menu,
      :p      => Pause
    }

    $musicGame.play

    # último quadrante visitado e quadrante atual
    @last_quatrant_x = 0
    @last_quatrant_y = 0
    @quatrant_x      = 0
    @quatrant_y      = 0 

    @width                  = ScreenWidth
    @height                 = ScreenHeight
    self.viewport.game_area = [0, 0, ScreenWidth * 3, ScreenHeight * 2]    # dimensões do mapa
    load_game_objects

    @parallax = Chingu::Parallax.new(:rotation_center => :top_left, :x => 32, :y => 32, :zorder => 0, :repeat_x => true, :repeat_y => true)
    @parallax << {:image => ImageDir+"/WallGray.jpg", :damping => 2, :repeat_x => true, :repeat_y => true}

    @subject = Subject.create(:x => 1152, :y => 760)
    
    # Objetos iniciados no primeiro quadrante (fase, tela, chamber... whatever)    
    @gate_q1 = Gate.create(:x => 1024, :y => 48)
    @SwitchButton_q1 = SwitchButton.create(:x => 160, :y => 112)
    # @SwitchButton_q1 = SwitchButton.create(:x => 64, :y => 448)
    @SwitchButton_q1.setTarget(@gate_q1)


    # Segundo quadrante
    @gate_q2 = Gate.create(:x => 2048, :y => 560)
    @vital_apparatus_vent_q2 = VitalApparatusVent.create(:x => 1376, :y => 30)

    @SwitchButton_q2 = SwitchButton.create(:x => 1312, :y => 112)
    @SwitchButton_q2.setTarget(@vital_apparatus_vent_q2)

    @SuperButton_q2 = HeavyDutySuperCollidingSuperButton.create(:x => 1088, :y => 112)
    @SuperButton_q2.setTarget(@gate_q2)

    # Terceiro quadrante
    @gate_q3 = Gate.create(:x => 2000, :y => 640, :angle => 90)
    @vital_apparatus_vent_q3 = VitalApparatusVent.create(:x => 2720, :y => 0)

    @SwitchButton_q3 = SwitchButton.create(:x => 2144, :y => 625)
    @SwitchButton_q3.setTarget(@vital_apparatus_vent_q3)
    
    @SwitchButton_q3_2 = SwitchButton.create(:x => 2100, :y => 625)
    @SwitchButton_q3_2.setTarget( ExcursionFunnel.all ) if ExcursionFunnel.size > 0

    @SuperButton_q3 = HeavyDutySuperCollidingSuperButton.create(:x => 2176, :y => 625)
    @SuperButton_q3.setTarget(@gate_q3)

    # Quarto quadrante
    @vital_apparatus_vent_q4 = VitalApparatusVent.create(:x => 1800, :y => 640)

    @SwitchButton_q4 = SwitchButton.create(:x => 1152, :y => 785)
    @SwitchButton_q4.setTarget(@vital_apparatus_vent_q4)
    
    @gate_q4 = Gate.create(:x => 1920, :y => 848)

    @SwitchButton_q4_2 = SwitchButton.create(:x => 1600, :y => 912)
    @SwitchButton_q4_2.setTarget( @gate_q4 )

    @gate_q4_2 = Gate.create(:x => 1920, :y => 1200)
    @SuperButton_q4 = HeavyDutySuperCollidingSuperButton.create(:x => 1800, :y => 785)
    # @SuperButton_q4 = HeavyDutySuperCollidingSuperButton.create(:x => 1060, :y => 1136)
    @SuperButton_q4.setTarget(@gate_q4_2)
  end

  def handle_death
    # contabilizar mortes
    # apagar ultimo cubo criado no VitalApparatusVent se o cubo "morrer"
  end

  def edit
    push_game_state(GameStates::Edit.new(:grid => [32,32], :classes => [HighEnergyPelletLauncher, VitalApparatusVent, Savepoint, Goo, ExcursionFunnel, BlockBlack, BlockGray, Chamberlock]), :finalize => false)
  end 

  def update
    super

    @quatrant_x = (@subject.x / ScreenWidth).to_i
    @quatrant_y = (@subject.y / ScreenHeight).to_i

    self.viewport.lag = 0.95  # velocidade de movimento na transição da viewport
    self.viewport.move_towards_target

    if self.viewport.outside?(@subject) then
      offset_x = if @quatrant_x > @last_quatrant_x then -1 else 1 end
      offset_y = if @quatrant_y > @last_quatrant_y then -1 else 1 end

      self.viewport.x_target = (ScreenWidth  * @quatrant_x) + offset_x if @quatrant_x != @last_quatrant_x
      self.viewport.y_target = (ScreenHeight * @quatrant_y) + offset_y if @quatrant_y != @last_quatrant_y

      @last_quatrant_x, @last_quatrant_y = @quatrant_x, @quatrant_y
    end

    @subject.each_collision(Chamberlock) do |player, chamber|
      chamber.checkpoint
      switch_game_state(Credits)
    end

    @parallax.camera_x = self.viewport.x + 5
    @parallax.camera_y = self.viewport.y
    @parallax.update
  end

  def draw
    @parallax.draw
    super    
  end

  def finalize
    # Elimina todos os objetos atuais para evitar que sejam "mesclados" na GameState seguinte
    # Não está funcionando como deveria
    self.game_objects.destroy_all
  end
end