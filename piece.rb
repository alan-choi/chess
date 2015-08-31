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
end

class Rook < SlidingPiece
  def moves
    #current position ( or what is selected)
    #look at the current row and col for emptyspaces
  end

end

class Queen < SlidingPiece
end

class Knight < SteppingPiece
end

class King < SteppingPiece
end
