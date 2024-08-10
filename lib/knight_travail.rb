module Knight
  def init_knight
    @movements = {
      -2 => [-1, 1],
      -1 => [-2, 2],
      1 => [-2, 2],
      2 => [-1, 1]
    }
  end

  def valid_movement?(new_position)
    new_position[0] < 8 && new_position[1] < 8 && new_position[0] >= 0 && new_position[1] >= 0
  end
end

class Graph
  include Knight
  attr_accessor :adjacency_list

  def initialize
    init_knight
    @adjacency_list = {}
  end

  def chess_board(position)
    return nil if position.nil? || valid_movement?(position) == false
    return if @adjacency_list.key?(position)

    x = position[0]
    y = position[1]
    @adjacency_list[position] = []
    @movements.each_pair do |dx, array|
      array.each do |dy|
        next unless valid_movement?([x + dx, y + dy])

        @adjacency_list[position].push([x + dx, y + dy])

        chess_board([x + dx, y + dy])
      end
    end
  end

  def knight_move(start_pos, end_pos)
    raise ArgumentError unless valid_movement?(start_pos) || valid_movement?(end_pos)
    return if start_pos == end_pos

    chess_board(start_pos) if @adjacency_list == {}

    queue = [[start_pos, [start_pos]]] # [current_position, path]
    visited = { start_pos => true }

    until queue.empty?
      current_position, path = queue.shift

      @adjacency_list[current_position].each do |movement|
        next if visited[movement]

        new_path = path + [movement]
        return new_path if movement == end_pos

        queue.push([movement, new_path])
        visited[movement] = true
      end
    end
  end
end
