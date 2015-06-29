# Triangle Project Code.

# Triangle analyzes the lengths of the sides of a triangle
# (represented by a, b and c) and returns the type of triangle.
#
# It returns:
#   :equilateral  if all sides are equal
#   :isosceles    if exactly 2 sides are equal
#   :scalene      if no sides are equal
#
# The tests for this method can be found in
#   about_triangle_project.rb
# and
#   about_triangle_project_2.rb
#

class TraingleError < RuntimeError
end

def triangle(a, b, c)
  
  if (a <= 0) || (b <= 0) || (c <= 0)
    raise TriangleError
  end
  
  if (a + b <= c) || (b + c <= a) || (c + a <= b)
    raise TriangleError
  end
  
  # WRITE THIS CODE
  if a == b && b == c
    :equilateral
  else
    if a != b && b != c && c != a
      :scalene
    else
      :isosceles
    end
  end
end

# Error class used in part 2.  No need to change this code.
class TriangleError < StandardError
end