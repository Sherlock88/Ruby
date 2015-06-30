require_relative "RoverController"
require "test/unit"
 
class TestRover < Test::Unit::TestCase
  
  def setup
    @rover_controller = RoverController.new "5 5"
  end
 
  def test_1
    @rover_controller.setLocation "1 2 N"
    rover_location = @rover_controller.sendCommand "LMLMLMLMM"
    assert_equal("1 3 N", rover_location)
  end
  
  def test_2
    @rover_controller.setLocation "3 3 E"
    rover_location = @rover_controller.sendCommand "MMRMMRMRRM"
    assert_equal("5 1 E", rover_location)
  end
  
  def test_3
    @rover_controller.setLocation "0 0 E"
    rover_location = @rover_controller.sendCommand "LLM"
    assert_equal("0 0 W", rover_location)
  end
  
  def test_4
    @rover_controller.setLocation "0 0 N"
    rover_location = @rover_controller.sendCommand "LLLL"
    assert_equal("0 0 N", rover_location)
  end
  
  def test_5
    @rover_controller.setLocation "0 0 E"
    rover_location = @rover_controller.sendCommand "MMMMML"
    assert_equal("5 0 N", rover_location)
  end
  
  def test_6
    @rover_controller.setLocation "0 0 W"
    rover_location = @rover_controller.sendCommand "MMMMMMMMM"
    assert_equal("0 0 W", rover_location)
  end
  
  def test_7
    @rover_controller.setLocation "5 5 N"
    rover_location = @rover_controller.sendCommand "MMMMMLM"
    assert_equal("4 5 W", rover_location)
  end
 
end