require_relative "Rover"
require_relative "Plateau"

class RoverController
  
  def initialize(grid_size)
    max_x, max_y = grid_size.split.map { |x| x.to_i }
    @plateau = Plateau.new max_x, max_y
  end
  
  
  def setLocation(initial_coordinates)
    initial_coordinates = initial_coordinates.chomp
    pos_x, pos_y, direction = initial_coordinates.split
    begin
      @rover = Rover.new pos_x.to_i, pos_y.to_i, direction, @plateau
    rescue ArgumentError => ex
      raise ArgumentError, ex
    end
  end
  
  
  def sendCommand(cmd_rover)
    cmd_rover = cmd_rover.chomp.split(//)
    cmd_rover.each { |cmd| 
      new_direction = @rover.move cmd
      if new_direction == 'I'
        raise ArgumentError, "Invalid command sent to the Rover"
      end
    }
    @rover.getLocation
  end

end
