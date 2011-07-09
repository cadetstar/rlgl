class Platform < Entity
  def initialize(mass, x_pos, y_pos, x_size, y_size, window)
    super(mass, x_pos, y_pos, x_size, y_size, window, false)
    self.shape.e = 0.0
    self.shape.u = 0.5
    self.shape.collision_type = :platform
  end
end