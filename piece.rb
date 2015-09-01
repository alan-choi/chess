require "byebug"

class Piece
  attr_reader :board, :position
  attr_accessor :occupied, :color, :position, :first_move

  def initialize(board, position, color = nil)
    @occupied = true
    @board = board
    @position = position
    @color = color
    @first_move = true
  end

  def occupied?
    @occupied
  end

  def enemy?(piece)
    piece.color != self.color && piece.occupied? && self.occupied?
  end

  def to_s
  end

  def moves
    []
  end

  def dup(new_board)
    new_piece = self.class.new(new_board, @position.dup, @color)
    new_piece.first_move = @first_move
    new_piece
  end

  def valid_moves
    self.moves.reject do |move|
      move_into_check?(move)
    end
  end

  def move_into_check?(pos)
    new_board = @board.dup
    new_board.move_piece!(self.position, pos)
    new_board.check?(self.color)
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
    directional_moves(position, [1,0]) +
    directional_moves(position, [-1,0])
  end
end

class Bishop < SlidingPiece
  def to_s
    "\u265D ".encode("utf-8")
  end

  def moves
    diagonal_moves
  end
end

class Rook < SlidingPiece
  # def initialize(board, position, color = nil)
  #   super(board, position, color)
  #   @occupied = true
  # end

  def to_s
    "\u265C ".encode("utf-8")
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
    "\u265B ".encode("utf-8")
  end
end

class SteppingPiece < Piece
  def moves
    moves = []
    self.move_steps.each do |step|
      y, x = step
      row, col = @position
      pos = [row + y, col + x]

      if @board.in_bounds?(pos)
        if !@board[*pos].occupied? || @board[*pos].enemy?(self)
          moves << pos
        end
      end
    end
    moves
  end
end

class Knight < SteppingPiece
  def to_s
    "\u265E ".encode("utf-8")
  end

  def move_steps
    [[1,2], [-1,2], [1,-2], [-1,-2], [2,1], [-2,1], [2,-1], [-2,-1]]
  end
end

class King < SteppingPiece
  def to_s
    "\u265A ".encode("utf-8")
  end

  def move_steps
    [[1,1], [1,0], [1,-1], [0,1], [0,-1], [-1,1], [-1,0], [-1,-1]]
  end
end

class Pawn < Piece
  attr_accessor :first_move

  def moves
    moves = []
    row, col = position
    y_step = (color == :white) ? -1 : 1

    moves << [row + y_step, col] unless @board[row + y_step, col].occupied?

    [-1,1].each do |i|
      pos = [row + y_step, col + i]
      if @board.in_bounds?(pos) && @board[*pos].enemy?(self)
        moves << pos
      end
    end

    if @first_move
      unless @board[row + y_step * 2, col].occupied? || @board[row + y_step, col].occupied?
        moves << [row + y_step * 2, col]
      end
    end

    moves
  end

  def to_s
    "\u265F ".encode("utf-8")
  end

end
