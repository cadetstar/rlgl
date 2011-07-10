class Prop < Entity
  def initialize(mass, detail_hash, window)
    super(mass, detail_hash, window, false)
    self.shape.e = 0.0
    self.shape.u = 0.5
    if !detail_hash['present'].nil? and detail_hash['present'].to_i == 1
      self.shape.collision_type = :platform
    else
      self.shape.collision_type = :none #this doesn't work! change it!
    end
    @rot = detail_hash[r].to_f
  end
  def draw(game_level)
    $w.rotate(@rot*90, @body.p.x - game_level.offset_x,@body.p.y) do
    @image.draw_as_quad(@body.p.x - game_level.offset_x + @shape.vert(0).x, @body.p.y + @shape.vert(0).y, @color,
                        @body.p.x - game_level.offset_x + @shape.vert(1).x, @body.p.y + @shape.vert(1).y, @color,
                        @body.p.x - game_level.offset_x + @shape.vert(2).x, @body.p.y + @shape.vert(2).y, @color,
                        @body.p.x - game_level.offset_x + @shape.vert(3).x, @body.p.y + @shape.vert(3).y, @color,
                        ZOrder::Platforms)
                        end
  end
end