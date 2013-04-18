#
# WeightedCompanionCube, elemento usado para destravar portas
#
class WeightedCompanionCube < GameObject
  trait :bounding_box, :debug => false
  trait :collision_detection
  traits :timer, :velocity

  attr_accessor :being_dragged, :can_interact, :kidnapper, :creator
  
  def self.inside_viewport
    all.select { |block| block.game_state.viewport.inside?(block) }
  end

  def initialize(options)
    super
    @creator = options[:creator]
  end

  def setup
    super
    @image = Image[ImageDir+"/cubes/companion-cube-32.png"]
    @color = Color.new(0xff808080)

    @being_dragged       = false
    @can_interact        = true
    @width               = @height = 32
    @kidnapper           = nil # guarda a instância de quem fica levando o cubo pelo cenário
    self.factor          = 1
    self.acceleration_y  = 0.9
    # self.acceleration_y  = 0.5
    self.max_velocity    = 3
    self.rotation_center = :bottom_center

    cache_bounding_box
    update
  end

  def can_interact?
    @can_interact
  end

  def die
    self.collidable = false
    @color = Color::RED.dup
    self.destroy
    
    @kidnapper.grabing = false unless @kidnapper.nil?
    @kidnapper = nil
    @creator.release! unless @creator.nil?
    # puts "o cubo morreu"
  end
  alias die! die

  def update
    # self.each_collision(Subject) do |me, subject|
    #   if( subject.grabing and @can_interact) then
    #     @being_dragged = true
    #     subject.last_object_being_grasped = me

    #     # TODO: fazer o cube ficar a frente do personagem e parar antes de ultrapassar um objeto sólido
    #     if(subject.face_direction == :left) then 
    #       me.x = subject.x
    #     elsif(subject.face_direction == :right) then
    #       me.x = subject.x
    #     end

    #     me.y = subject.y - 10
    #   else
    #     @being_dragged = false
    #   end
    # end

    # Simula a queda pela "gravidade"
    if not(@being_dragged) then
      self.each_collision(BlockBlack, BlockGray, Gate) do |me, stone_wall|
        if @velocity_y < 0  # Hitting the ceiling
          me.y = stone_wall.bb.bottom + me.image.height * @factor_y
          @velocity_y = 0
        else  # Land on ground
          # me.y = stone_wall.bb.top-1
          me.y = previous_y
        end
      end
    end
  end
end