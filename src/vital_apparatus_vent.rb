#
# VitalApparatusVent: Cria um novo cubo
#
class VitalApparatusVent < GameObject
  traits :bounding_box, :timer

  attr_reader :last_object_created

  def setup
    @image               = Image[ImageDir+"/structures/vital_apparatus_vent.png"]
    @last_object_created = nil
    self.zorder          = ZOrder::Stuff

    cache_bounding_box
  end

  def release!
    @last_object_created = nil
  end

  # Metodo em comum entre todos os objetos "interagíveis" do jogo
  # Serve como atalho para o seu método de ação específico
  def toggle_status
  	self.drop if @last_object_created.nil?
  end
  alias toggle_status! toggle_status
  
  def drop
    @last_object_created = WeightedCompanionCube.create(:x => self.bb.centerx, :y => self.bb.bottom + 30, :creator => self)
  end
end