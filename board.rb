load './piece.rb'

class Board
  attr_reader :grid
  def initialize
    @grid = Array.new(8) { Array.new(8) }
    populate_board
  end

  def populate_board
    @grid.each.with_index do |row, row_idx|
      row.each.with_index do |col, col_idx|
        @grid[row_idx][col_idx] = EmptySpace.new(self, [row_idx, col_idx])
      end
    end
  end

  def move(start_pos, end_pos)

    raise NoPieceFound unless self[start_pos].occupied?
    raise InvalidMove unless valid_move?(start_pos, end_pos)

    piece = self[start_pos]
    self[start_pos] = EmptySpace.new(self, [row_idx, col_idx])
    kill_piece(end_pos)
    self[end_pos] = piece
  end

  def [](col, row)
    @grid[row][col]
  end

  def []=(col, row, val)
    @grid[row][col] = val
  end

end
