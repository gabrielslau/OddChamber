#
# Subject
#
class Subject < Chingu::GameObject
  trait :bounding_box, :debug => false, :scale => 0.80
  traits :timer, :collision_detection , :timer, :velocity
  
  attr_reader :jumping, :face_direction, :width, :height, :buttonAction, :buttonGrab
  attr_accessor :moving, :tounchingWeightedCompanionCube, :grabing, :last_object_being_grasped, :saved_x, :saved_y, :collidable
  
  def setup

    self.input = {  
      :holding_left        => :holding_left, 
      :holding_right       => :holding_right,
      :holding_left_shift  => :boost_speed,
      :released_left_shift => :normalize_speed,
      :space               => :jump
    }
    
    @width  = 22
    @height = 32
    
    # Load the full animation from tile-file media/subject.bmp
    @animations = Chingu::Animation.new(:file => ImageDir+"/characters/player2_22x32.png")
    @animations.frame_names = { :left => 4..7, :right => 0..3 }
    
    @current_state             = :idle
    @face_direction            = :right
    @grabing                   = false
    
    @buttonAction              = Button::KbF
    @buttonGrab                = Button::KbG
    
    @speed_low                 = 5
    @speed_normal              = 8
    @speed_fast                = 12
    @speed                     = @speed_normal
    @jumping                   = false
    @jumping_count             = 0
    @last_object_being_grasped = nil
    
    self.moving                = @moving = false
    self.zorder                = 300
    self.factor                = 1
    self.acceleration_y        = 0.5 # foça da gravidade
    self.max_velocity          = 10
    self.rotation_center       = :bottom_center
    
    self.saved_x               = self.x
    self.saved_y               = self.y

    setAnimation()
    
    update
  end

  def setAnimation
    @animation = @animations[@face_direction]
  end
  
  def boost_speed
    @speed = if not @grabing then @speed_fast else @speed_normal end
    @current_state  = :running
  end

  def normalize_speed
    @speed = @speed_normal  if not @grabing
  end

  def holding_left
    move(-@speed, 0)
    @current_state  = :walking
    @face_direction = :left
    setAnimation
  end

  def holding_right
    move(@speed, 0)
    @current_state  = :walking
    @face_direction = :right
    setAnimation
  end

  def jump
    if (@jumping and @jumping_count == 2) then
      return
    end

    @jumping = true
    self.velocity_y = -7
    @current_state = :jumping
    setAnimation

    @jumping_count += 1
    # Sound[SoundDir+"/sfx/jump.wav"].play
  end
  
  def move(x,y)
    super
    self.each_bounding_box_collision(BlockGray, BlockBlack, Gate) do |me, solid_stuff|
      self.x  = previous_x
      @moving = false
    end
  end

  def set_object_being_grasped(object = nil)
    @last_object_being_grasped = object if not( object.nil? )
  end

  def die
    self.collidable       = false
    @grabing              = false
    @color                = Color::RED.dup
    between(1, 200) { 
      self.velocity_y    = 0; 
      self.scale         += 0.4; 
      self.alpha         -= 5; 
      # self.rotation_rate = 5
    }.then { reborn! }
    
    # reseta o estado normal do Cubo para evitar que ele transpasse o cenário
    @last_object_being_grasped.being_dragged = false if not(@last_object_being_grasped.nil?)
    @last_object_being_grasped.y -= 10 if not(@last_object_being_grasped.nil?)

    # game_state.handle_death
  end
  alias die! die

  def reborn_in_savepoint
    self.alpha      = 255
    self.factor     = 1
    self.collidable = true
    @color          = Color::WHITE.dup
    
    self.x          = @saved_x
    self.y          = @saved_y
    # game_state.restore_player_position
  end
  alias reborn! reborn_in_savepoint

  def update
    @image = if @current_state == :idle then @animation.first else @animation.next end # @image is drawn by default by GameObject#draw

    # self.each_collision(Goo) do |me, target|
    #   me.die!
    # end

    # segura o WeightedCompanionCube somente se estiver em contato com ele
    if WeightedCompanionCube.size > 0 then
      self.each_collision( WeightedCompanionCube ) do |me, cube|
        if( $window.button_down?(  @buttonGrab  ) ) then
          
          # adiciona um delay. Tem que melhorar isso!
          after(10) {
            if not(@grabing) and cube.can_interact? then
              @grabing = cube.being_dragged = true
              @last_object_being_grasped    = cube
              cube.kidnapper                = me
            elsif @grabing then 
              @grabing = cube.being_dragged = not(@grabing)
            end
          }


          # TODO: fazer o cube ficar a frente do personagem e parar antes de ultrapassar um objeto sólido
        end

        if @grabing then
          cube.x = me.x if @face_direction == :left or @face_direction == :right
          cube.y = @y - 9
        end
      end
    end

    # Diminui a velocidade do personagem se tiver carregando o cubo
    @speed = if @grabing then @speed_low else @speed_normal end

    

    self.each_collision(BlockGray, BlockBlack, Gate) do |me, solid_stuff|
      if self.velocity_y < 0  # Batendo a cabeça no topo
        me.y            = solid_stuff.bb.bottom + me.image.height * self.factor_y
        self.velocity_y = 0
        @moving         = true
      else  # Land on ground
        @jumping       = false
        @jumping_count = 0
        # me.y         = solid_stuff.bb.top # here's the problem
        me.y           = previous_y
        # me.x           = previous_x if solid_stuff.angle and solid_stuff.angle == 90
      end
    end
    
    unless moved? then
      @moving = false
      @current_state  = :idle
      setAnimation
    else
      @moving = true
    end
  end
end