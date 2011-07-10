class Goal < Entity
  def initialize(mass, detail_hash, window)
    super(mass, detail_hash, window, false)
    self.shape.e = 0.0
    self.shape.u = 0.5
    self.shape.collision_type = :goal
    @image = Gosu::Image.new(window, "#{$preface}media/goal.png")
  end
end