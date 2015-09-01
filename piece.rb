require "byebug"

class Piece
  attr_reader :board, :position
  attr_accessor :occupied, :color

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

  def diagonal_moves
    directional_moves(position, [-1, 1]) +
    directional_moves(position, [1,-1]) +
    directional_moves(position, [-1, -1]) +
    directional_moves(position, [1, 1])
  end

  def directional_moves(position, steps)
    spaces = []
    row, col = position
    row_step, col_step = steps
    col += col_step
    row += row_step
    while @board.in_bounds?([col ,row]) && !@board[row, col].occupied?
      spaces << [row, col]
      col += col_step
      row += row_step
    end
    spaces << [row, col] if @board.in_bounds?([row, col]) && @board[row, col].enemy?(self)
    spaces
  end

  def horizontal_moves
    directional_moves(position, [0,1]) +
    directional_moves(position, [0,-1])
  end

  def vertical_moves
    directional_moves(postion, [1,0]) +
    directional_moves(position, [-1,0])
  end
end

class SteppingPiece < Piece

end

class Bishop < SlidingPiece
  def to_s
    "\u2657 ".encode("utf-8")
  end

  def moves
    diagonal_moves
  end
end

class Rook < SlidingPiece
  def initialize(board, position, color = nil)
    super(board, position, color)
    @occupied = true
  end

  def to_s
    "\u2656 ".encode("utf-8")
  end
  def moves
    horizontal_moves + vertical_moves
  end

end

class Queen < SlidingPiece
  def moves
    diagonal_moves + horizontal_moves + vertical_moves
  end
  def to_s
    "\u2655 ".encode("utf-8")
  end
end

class Knight < SteppingPiece
  def to_s
    "\u2658 ".encode("utf-8")
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
    "\u2654 ".encode("utf-8")
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
  attr_accessor :first_move

  def initialize(board, position, color=nil)
    super(board, position, color)
    @first_move = true
  end

  def moves
    moves = []
    row, col = position
    y_step = (color == :white) ? -1 : 1

    moves << [row + y_step, col] unless @board[row + y_step, col].occupied?

    moves << [row + y_step, col + 1] if @board[row + y_step, col + 1].enemy?(self)
    moves << [row + y_step, col - 1] if @board[row + y_step, col - 1].enemy?(self)

    if @first_move
      unless @board[row + y_step * 2, col].occupied? || @board[row + y_step, col].occupied?
        moves << [row + y_step * 2, col]
      end
    end

    moves

  end

  def to_s
    "\u2659 ".encode("utf-8")
  end

end
