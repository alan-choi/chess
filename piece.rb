require "byebug"

class Piece
  attr_reader :board, :position, :color
  attr_accessor :occupied

  def initialize(board, position, color = nil)
    @occupied = true
    @board = board
    @position = position
    @color = color
  end

  def occupied?
    @occupied
  end

  def enemy?(piece)
    if piece.color != self.color && piece.occupied? && self.occupied?
      return true
    else
      false
    end
  end

  def to_s

  end

  def moves

  end
end

class EmptySpace < Piece
  def initialize(board, position, color = nil)
    super(board, position, color)
    @occupied = false

  end

  def to_s
    "  "
  end

end

class SlidingPiece < Piece
  def moves #returns array of possible positions

  end

  def diagonal_moves
    directional_moves(position, [-1, 1]) +
    directional_moves(position, [1,-1]) +
    directional_moves(position, [-1, -1]) +
    directional_moves(position, [1, 1])
  end

  def directional_moves(position, steps)
    spaces = []
    col, row = position
    row_step, col_step = steps
    col += col_step
    row += row_step
    while @board.in_bounds?([col ,row]) && !@board[col, row].occupied?
      spaces << [col, row]
      col += col_step
      row += row_step
    end
    spaces << [col, row] if @board.in_bounds?([col,row]) && @board[col,row].enemy?(self)
    spaces
  end

  def horizontal_moves
    directional_moves(position, [0,1])
    # directional_moves(position, ADD STEP)
  end

  def vertical_moves
    # directional_moves(postion, ADD STEP) +
    # directional_moves(position, ADD STEP)
  end
end

class SteppingPiece < Piece

end

class Bishop < SlidingPiece
  def to_s
    "B "
  end
end

class Rook < SlidingPiece
  def initialize(board, position, color = nil)
    super(board, position, color)
    @occupied = true
  end

  def to_s
    "R "
  end
  def moves
    #current position ( or what is selected)
    #look at the current row and col for emptyspaces
  end

end

class Queen < SlidingPiece
  def to_s
    "Q "
  end
end

class Knight < SteppingPiece
  def to_s
    "N "
  end
  def moves
    y,x = @position
    moves = []
    (-2..2).each do |row|
      (-2..2).each do |col|
        position = [row + y, col + x]
        if (row.abs + col.abs) == 3 && @board.in_bounds?(position)
          if !@board[*position].occupied? || @board[*position].enemy?(self)
            moves << position
          end
        end
      end
    end
    moves
  end
end

class King < SteppingPiece
  def to_s
    "K "
  end

  def moves
    moves = []
    y,x = @position
    (-1..1).each do |row|
      (-1..1).each do |col|
        position = [row + y, col + x]
        if @board.in_bounds?(position)
          if !@board[*position].occupied? || @board[*position].enemy?(self)
            moves << position unless [row, col] == [0, 0]
          end
        end
      end
    end
    moves
  end
end

class Pawn < Piece

  def to_s
    "P "
  end

end
