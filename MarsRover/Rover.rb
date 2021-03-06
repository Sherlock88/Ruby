=begin

A squad of robotic rovers are to be landed by NASA on a plateau on Mars.
This plateau, which is curiously rectangular, must be navigated by the
rovers so that their on-board cameras can get a complete view of the
surrounding terrain to send back to Earth.

A rover's position and location is represented by a combination of x and y
co-ordinates and a letter representing one of the four cardinal compass
points. The plateau is divided up into a grid to simplify navigation. An
example position might be 0, 0, N, which means the rover is in the bottom
left corner and facing North.

In order to control a rover, NASA sends a simple string of letters. The
possible letters are 'L', 'R' and 'M'. 'L' and 'R' makes the rover spin 90
degrees left or right respectively, without moving from its current spot.
'M' means move forward one grid point, and maintain the same heading.

Assume that the square directly North from (x, y) is (x, y+1).

INPUT:
The first line of input is the upper-right coordinates of the plateau, the
lower-left coordinates are assumed to be 0,0.

The rest of the input is information pertaining to the rovers that have
been deployed. Each rover has two lines of input. The first line gives the
rover's position, and the second line is a series of instructions telling
the rover how to explore the plateau.

The position is made up of two integers and a letter separated by spaces,
corresponding to the x and y co-ordinates and the rover's orientation.

Each rover will be finished sequentially, which means that the second rover
won't start to move until the first one has finished moving.


OUTPUT
The output for each rover should be its final co-ordinates and heading.

INPUT AND OUTPUT

Test Input:
5 5
1 2 N
LMLMLMLMM
3 3 E
MMRMMRMRRM

Expected Output:
1 3 N
5 1 E

=end

class Rover
  
  attr_reader :pos_x
  attr_reader :pos_y
  attr_reader :direction
  
  
  def initialize(pos_x, pos_y, direction, plateau)
    @pos_x = pos_x
    @pos_y = pos_y
    @direction = direction
    @max_x = plateau.max_x
    @max_y = plateau.max_y
    
    raise ArgumentError, "Rover location is outside of the plateau" if ((@pos_x > @max_x) || (@pos_y > @max_y))
  end
  
  
  def move_rover
    case @direction
    when 'N'
      @pos_y = (@pos_y == @max_y) ? @pos_y : (@pos_y + 1)
    when 'S'
      @pos_y = (@pos_y == 0) ? 0 : (@pos_y - 1)
    when 'E'
      @pos_x = (@pos_x == @max_x) ? @pos_x : (@pos_x + 1)
    when 'W'
      @pos_x = (@pos_x == 0) ? 0 : (@pos_x - 1)
    end
  end
  
  
  def move(cmd_rover)
    rover_direction = { 'LN' => 'W', 'LS' => 'E', 'LE' => 'N', 'LW' => 'S', 'RN' => 'E', 'RS' => 'W', 'RE' => 'S', 'RW' => 'N' }
    rover_direction.default = 'I'
    if cmd_rover == 'M'
      move_rover
    else
      cmd_key = cmd_rover + @direction
      new_direction = rover_direction[cmd_key]
      if new_direction == 'I'
        new_direction
      else
        @direction = new_direction
      end
    end
  end
  
  
  def getLocation
    "#{pos_x} #{pos_y} #{direction}"
  end
end
