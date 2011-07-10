class Damager < Entity
  def initialize(mass, x_pos, y_pos, x_size, y_size, hs, vs, window)
    super(mass, x_pos, y_pos, x_size, y_size, hs, vs, window, false)
    self.shape.e = 0.0
    self.shape.u = 0.5
    self.shape.collision_type = :damager
    @image = Gosu::Image.new(window, "#{$preface}media/spikes.png")
  end

end