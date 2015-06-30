require_relative "RoverController"

grid_size = gets
max_x, max_y = grid_size.split.map { |x| x.to_i }
while true
  initial_coordinates = gets
  if initial_coordinates == nil
    break
  end
  initial_coordinates = initial_coordinates.chomp
  pos_x, pos_y, direction = initial_coordinates.split
  rover = Rover.new pos_x.to_i, pos_y.to_i, direction, max_x, max_y
  cmd_rover = gets.chomp.split(//)
  cmd_rover.each { |cmd| rover.move cmd }
  puts rover.getLocation
end
