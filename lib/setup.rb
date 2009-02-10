class Setup
  def initialize
    @screen = Screen.new [800,600], 0, [Rubygame::HWSURFACE,Rubygame::DOUBLEBUF]
    @queue = Rubygame::EventQueue.new
    @control = Controller.new(@screen)
  end

  def run
    @control.run
  end
end

