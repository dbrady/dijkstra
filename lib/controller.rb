require 'ostruct'

require File.expand_path(File.join(File.dirname(__FILE__), 'planet'))

class Controller
  include Rubygame
  PLANETS = 1000
  IN_COLOR = [0,255,255]
  OUT_COLOR = [255,255,0]
  LINK_COLOR = [0,128,128]
  TRIAL_LINK_COLOR = [128,128,0]
  
  def initialize(screen)
    @screen = screen
    @queue = Rubygame::EventQueue.new
    @clock = Rubygame::Clock.new
    @clock.target_framerate = 30

    w = @screen.width
    h = @screen.height
    @cx, @cy = w/2, h/2
    @center = @cx, @cy

    @planets = []
    radix = [1, PLANETS / 20].max
    1.upto(PLANETS) do |i|
      @planets << Planet.new(@screen, rand(w), rand(h), OUT_COLOR, 3, TRIAL_LINK_COLOR)
      puts "Generated #{i}/#{PLANETS} planets..." if i % radix == 0
    end
    
    @outs = @planets.dup
    @ins = []
    p = @outs.shift
    p.color = [255,0,0]
    p.link_color = [255,0,0]
    acquire p
  end
  
  def acquire(p)
    p.color = IN_COLOR
    p.link_color = LINK_COLOR
    @outs.each do |o|
      o.consider p
    end
    @ins << p
  end

  def run
    puts "Beginning controller run event"
    @last_frame_time ||= Time.now
    loop do
      @this_frame_time = Time.now
      @frame_time = @this_frame_time - @last_frame_time
      @queue.each do |ev|
        case ev
        when QuitEvent
          quit
          exit
#        when MouseDownEvent
# #          puts "Mouse Down Event: #{ev.inspect}"
#           @targets << OpenStruct.new(:angle => Math.atan2((ev.pos[1]-@cy), (ev.pos[0]-@cx)) - @angle, :dist => Math.sqrt((@cx-ev.pos[0])**2 + (@cy-ev.pos[1])**2))
#           @hotline = 255
        when KeyDownEvent
          case ev.key
          when K_ESCAPE
            quit
            exit
          end
        end
      end
      fps_update
      update_scene
      draw_scene
      @clock.tick
      @last_frame_time = @this_frame_time
    end
    puts "Finished controller run event"
  end

  def update_scene
    if @outs.size > 0
      @outs = @outs.sort_by {|o| o.distance }
      acquire @outs.shift
    end
  end
  
  def draw_scene
    @screen.fill [0,32,0]
    @planets.each {|p| p.draw_link}
    @planets.each {|p| p.draw}
    @screen.flip
  end
  
  def fps_update
    @screen.title = "FPS: #{'%2.3f' % @clock.framerate}"
  end
end


