$LOAD_PATH.unshift File.expand_path('lib', __dir__)

require 'nonogram'

# change the nonogram puzzle inputs here (as function parameters)
# as array of array of number
solution = Nonogram.new(
  [[3], [1,3], [3,1], [1,2], [1]],    # row (top - bottom)
  [[3], [1,1], [5], [2,1], [2]]       # columns (left - right)
)

# print the result
puts solution.solve.to_s
