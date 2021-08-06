class Nonogram
  def initialize(rows, cols)
    @rows = rows
    @cols = cols
    @solution = Array.new(rows.size) { Array.new(cols.size, ' ') }
    @complete_row = Array.new(@rows.size, false)
    @complete_col = Array.new(@cols.size, false)
    @changed = false
  end

  def solve
    # greedy approach to directly fill any rows/cols with obvious correct answer
    @rows.each_with_index { |row, idx| fill_if_full(row, @cols.size, idx, true) }
    @cols.each_with_index { |col, idx| fill_if_full(col, @rows.size, idx, false) }

    # loop until it is done or there is some changes
    while !done? && @changed
      @rows.each_with_index { |row, idx| fill_if_done(row, @cols.size, idx, true) unless @complete_row[idx] }
      @cols.each_with_index { |col, idx| fill_if_done(col, @rows.size, idx, false) unless @complete_col[idx] }

      break if done?

      @changed = false
      @rows.each_with_index { |row, idx| fill_if_intersect(row, @cols.size, idx, true) unless @complete_row[idx] }
      @cols.each_with_index { |col, idx| fill_if_intersect(col, @rows.size, idx, false) unless @complete_col[idx] }
    end

    @solution
  end

  private

  # check if the solution is done
  def done?
    @complete_row.all? && @complete_col.all?
  end

  # fill the answer per cell
  # will raise error if the cell has already filled with different value
  def fill(row, col, value)
    return if @solution[row][col] == value

    unless @solution[row][col] == ' '
      raise "cell [#{row},#{col}] has value '#{@solution[row][col]}'"
    end

    @solution[row][col] = value
    @changed = true
  end

  # fill the row/col with full answer if the condition meets
  # ex. row [5] with size 5   -> 'ooooo'
  #     row [1,3] with size 5 -> 'oxooo'
  def fill_if_full(nums, size, idx, isRow)
    return if nums.size == 1 && nums.first != size
    return unless (nums.sum + nums.size - 1) == size

    step = 0

    nums.each do |num|
      num.times do
        fill(isRow ? idx : step, isRow ? step : idx, 'o')
        step += 1
      end

      unless step == size
        fill(isRow ? idx : step, isRow ? step : idx, 'x')
        step += 1
      end
    end

    (isRow ? @complete_row : @complete_col)[idx] = true
  end

  # complete the row/col if the row/col is done
  # fill the other cells with 'x'
  def fill_if_done(nums, size, idx, isRow)
    check_idx = 0
    counter = 0

    row_idx = isRow ? idx : 0
    col_idx = isRow ? 0 : idx

    size.times do
      if @solution[row_idx][col_idx] == 'o'
        counter += 1
      else
        check_idx += 1 if check_idx < size && counter == nums[check_idx]
        counter = 0
      end

      isRow ? col_idx += 1 : row_idx += 1
    end

    return unless check_idx == nums.size

    size.times do |tidx|
      if @solution[isRow ? idx : tidx][isRow ? tidx : idx] == ' '
        fill(isRow ? idx : tidx, isRow ? tidx : idx, 'x')
      end
    end
    (isRow ? @complete_row : @complete_col)[idx] = true
  end

  # create two temporary arrays which is filled with the puzzle numbers
  # - first array filled from the start
  # - second array filled from the end
  # then it will be compared and if the same index is equal then fill it with 'o'
  def fill_if_intersect(nums, size, idx, isRow)
    current_line = []

    size.times do |tidx|
      current_line << @solution[isRow ? idx : tidx][isRow ? tidx : idx]
    end

    from_start = current_line.clone
    from_end = current_line.clone

    start_idx = 0
    nums.each_with_index do |num, tidx|
      range = start_idx...start_idx + num

      while start_idx + num < size && from_start[range].any?('x')
        first_occ = from_start[range].index('x')

        from_start.fill('x', start_idx...start_idx + first_occ)

        start_idx += first_occ + 1
        range = start_idx...start_idx + num
      end

      return if start_idx >= size

      range_end = start_idx + num

      from_start.fill(tidx, start_idx...range_end)
      from_start[range_end] = -1 if range_end < size
      start_idx += range_end + 1
    end

    end_idx = size - 1
    nums.reverse.each_with_index do |num, tidx|
      range = end_idx - num + 1..end_idx

      while end_idx >= 0 && from_end[range].any?('x')
        first_occ = from_end[range].reverse.index('x')

        from_end.fill('x', end_idx - first_occ..end_idx)

        end_idx = end_idx - first_occ - 1
        range = end_idx - num + 1..end_idx
      end

      return if end_idx < 0

      range_end = end_idx - num + 1

      from_end.fill(nums.size - tidx - 1, range_end..end_idx)
      from_end[range_end - 1] = -1 if range_end - 1 >= 0
      end_idx = end_idx - range_end - 1
    end

    current_line.size.times do |tidx|
      if from_start[tidx] == from_end[tidx] && from_start[tidx].is_a?(Integer)
        fill(
          isRow ? idx : tidx,
          isRow ? tidx : idx,
          from_start[tidx] < 0 ? 'x' : 'o'
        )
      end
    end
  end
end

# change the nonogram puzzle inputs here (as function parameters)
# as array of array of number
solution = Nonogram.new(
  [[3], [1,3], [3,1], [1,2], [1]],    # row (top - bottom)
  [[3], [1,1], [5], [2,1], [2]]       # columns (left - right)
)

# print the result
puts solution.solve.map(&:join).join("\n").gsub('x', ' ')
