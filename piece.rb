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

  end

  def horizontal_moves
    col, row = @position
    right_spaces = []
    left_spaces = []

    until col > 7 || @board[col, row].occupied?
        right_spaces << [col, row]
        col += 1
    end

    if col <= 7 && @board[col, row].enemy?(self)
      right_spaces << [col, row]
    end

    col = @position[0]
    until col < 0 || @board[col, row].occupied?
      left_spaces <<  [col, row]
      col -=1
    end
    if col >= 0 && @board[col, row].enemy?(self)
      left_spaces << [col, row]
    end

    right_spaces + left_spaces - [@position]
  end

  def vertical_moves
    col, row = @position
    top_spaces = []
    bottom_spaces = []

    until row > 7 || @board[col, row].occupied?
      top_spaces << [col, row]
      row += 1
    end

    top_spaces << [col, row]  if row <= 7 && @board[col, row].enemy?(self)

    row = @position[1]
    until row < 0 || @board[col, row].occupied?
      bottom_spaces <<  [col, row]
      row -=1
    end

    bottom_spaces << [col, row] if row >= 0 && @board[col, row].enemy?(self)

    top_spaces + bottom_spaces - [@position]
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

end
