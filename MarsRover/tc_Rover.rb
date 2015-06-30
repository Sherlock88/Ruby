require_relative "RoverController"
require_relative "Rover"
require_relative "Plateau"
require "test/unit"
 
class TestRover < Test::Unit::TestCase
  
  def setup
    @plateau = Plateau.new 20, 15
    @rover = Rover.new 10, 8, 'N', @plateau
    @rover_controller = RoverController.new "5 5"
  end

  def test_plateau
    assert_equal(@plateau.max_x, 20)
    assert_equal(@plateau.max_y, 15)
  end
  
  def test_rover_correct_initial_placement
    assert_equal(@rover.pos_x, 10)
    assert_equal(@rover.pos_y, 8)
    assert_equal(@rover.direction, 'N')
  end
  
  def test_rover_incorrect_initial_placement_outside_plateau
    assert_raise ArgumentError do
      Rover.new 25, 10, "N", @plateau
    end
  end

  def test_rover_send_invalid_command
    plateau = Plateau.new 10, 10
    rover = Rover.new 5, 5, "N", plateau
    direction = rover.move 'I'
    assert_equal(direction, 'I')
  end
  
  def test_rover_send_invalid_command
    plateau = Plateau.new 10, 10
    rover = Rover.new 5, 5, "N", plateau
    direction = rover.move 'I'
    assert_equal(direction, 'I')
  end
  
  def test_rover_direction_north_command_L
    rover = Rover.new 5, 5, "N", @plateau
    rover.move 'L'
    assert_equal(rover.direction, 'W')
  end
  
  def test_rover_direction_south_command_L
    rover = Rover.new 5, 5, "S", @plateau
    rover.move 'L'
    assert_equal(rover.direction, 'E')
  end
  
  def test_rover_direction_east_command_L
    rover = Rover.new 5, 5, "E", @plateau
    rover.move 'L'
    assert_equal(rover.direction, 'N')
  end
  
  def test_rover_direction_west_command_L
    rover = Rover.new 5, 5, "W", @plateau
    rover.move 'L'
    assert_equal(rover.direction, 'S')
  end
  
  def test_rover_direction_north_command_R
    rover = Rover.new 5, 5, "N", @plateau
    rover.move 'R'
    assert_equal(rover.direction, 'E')
  end
  
  def test_rover_direction_south_command_R
    rover = Rover.new 5, 5, "S", @plateau
    rover.move 'R'
    assert_equal(rover.direction, 'W')
  end
  
  def test_rover_direction_east_command_R
    rover = Rover.new 5, 5, "E", @plateau
    rover.move 'R'
    assert_equal(rover.direction, 'S')
  end
  
  def test_rover_direction_west_command_R
    rover = Rover.new 5, 5, "W", @plateau
    rover.move 'R'
    assert_equal(rover.direction, 'N')
  end
  
  def test_rover_controller_set_incorrect_location_outside_plateau
    assert_raise ArgumentError do
      @rover_controller.setLocation "100 50 N"
    end
  end
  
  def test_rover_controller_sent_incorrect_command_to_rover
    @rover_controller.setLocation "5 5 N"
    assert_raise ArgumentError do
      @rover_controller.sendCommand "G"
    end
  end
  
  def test_rover_movement_1
    @rover_controller.setLocation "1 2 N"
    rover_location = @rover_controller.sendCommand "LMLMLMLMM"
    assert_equal("1 3 N", rover_location)
  end
  
  def test_rover_movement_2
    @rover_controller.setLocation "3 3 E"
    rover_location = @rover_controller.sendCommand "MMRMMRMRRM"
    assert_equal("5 1 E", rover_location)
  end
  
  def test_rover_movement_3
    @rover_controller.setLocation "0 0 E"
    rover_location = @rover_controller.sendCommand "LLM"
    assert_equal("0 0 W", rover_location)
  end
  
  def test_rover_movement_4
    @rover_controller.setLocation "0 0 N"
    rover_location = @rover_controller.sendCommand "LLLL"
    assert_equal("0 0 N", rover_location)
  end
  
  def test_rover_movement_5
    @rover_controller.setLocation "0 0 E"
    rover_location = @rover_controller.sendCommand "MMMMML"
    assert_equal("5 0 N", rover_location)
  end
  
  def test_rover_movement_6
    @rover_controller.setLocation "0 0 W"
    rover_location = @rover_controller.sendCommand "MMMMMMMMM"
    assert_equal("0 0 W", rover_location)
  end
  
  def test_rover_movement_7
    @rover_controller.setLocation "5 5 N"
    rover_location = @rover_controller.sendCommand "MMMMMLM"
    assert_equal("4 5 W", rover_location)
  end
  
end