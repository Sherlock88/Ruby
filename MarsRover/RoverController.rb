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
    @rover = Rover.new pos_x.to_i, pos_y.to_i, direction, @plateau
  end
  
  
  def sendCommand(cmd_rover)
    cmd_rover = cmd_rover.chomp.split(//)
    cmd_rover.each { |cmd| @rover.move cmd }
    @rover.getLocation
  end

end
