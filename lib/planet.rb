class Planet
  attr_accessor :screen, :x, :y, :link, :distance, :color, :link_color, :size
  
  def initialize(screen, x, y, color=[0,255,255], size=3, link_color=[0,128,128])
    @screen, @x, @y, @color, @size, @link_color = screen, x, y, color, size, link_color
    @link = nil
    @distance = nil
    @distances = { }
  end

  def draw_link
    @screen.draw_line [x, y], [@link.x, @link.y], @link_color if @link
  end
  
  def dist2(p)
    (x-p.x)**2 + (y-p.y)**2
  end

  def draw
    @screen.draw_circle [@x,@y], @size, @color
  end
  
  def consider(p)
    d = dist2 p
    if @distance.nil? || d < @distance
      @distance = d
      @link = p
    end
  end
end
