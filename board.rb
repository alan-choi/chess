load './piece.rb'

class Board
  ROOKS = [[0,0], [0,7], [7,0], [7,7]]
  KNIGHTS = [[0,1], [0,6], [7,1], [7,6]]
  BISHOPS = [[0,2], [0,5], [7,2], [7,5]]
  QUEENS = [[0,3], [7,3]]
  KINGS = [[0,4], [7,4]]


  attr_reader :grid
  def initialize(new_board = true)
    @grid = Array.new(8) { Array.new(8) }
    populate_board if new_board
  end

  def populate_board
    8.times do |row_idx|
      8.times do |col_idx|
        @grid[row_idx][col_idx] = EmptySpace.new(self, [row_idx, col_idx])
      end
    end

    ROOKS.each { |pos| self[*pos] = Rook.new(self,pos)}
    KNIGHTS.each { |pos| self[*pos] = Knight.new(self,pos)}
    BISHOPS.each { |pos| self[*pos] = Bishop.new(self,pos)}
    QUEENS.each { |pos| self[*pos] = Queen.new(self,pos)}
    KINGS.each { |pos| self[*pos] = King.new(self,pos)}
    pawn_positions.each { |pos| self[*pos] = Pawn.new(self,pos)}

    set_colors
  end

  def set_colors
    @grid[0..1].each {|row| row.map { |piece| piece.color = :black} }
    @grid[6..7].each {|row| row.map { |piece| piece.color = :white} }
  end

  def pawn_positions
    pawns = []
    8.times do |pawn_idx|
      pawns << [1, pawn_idx]
      pawns << [6, pawn_idx]
    end
    pawns
  end

  def check?(color)
    king_pos = self.grid.flatten.select do |piece|
      piece.is_a?(King) && piece.color == color
    end.first.position

    moves = []
    self.grid.flatten.each do |piece|
      moves += piece.moves if piece.color != color
    end

    moves.include?(king_pos)
  end

  def opposite_color(color)
    return :black if color == :white
    return :white if color == :black
  end

  def dup
    new_board = Board.new(false)
    8.times do |row_idx|
      8.times do |col_idx|
        new_board[row_idx, col_idx] = self[row_idx, col_idx].dup(new_board)
      end
    end
    new_board
  end

  def move_piece(start_pos, end_pos)

    raise NoPieceFound unless self[*start_pos].occupied?
    raise InvalidMove unless valid_move?(start_pos, end_pos)

    move_piece!(start_pos, end_pos)
  end

  def move_piece!(start_pos, end_pos)
    piece = self[*start_pos]
    self[*start_pos] = EmptySpace.new(self, start_pos)
    self[*end_pos] = piece
    piece.position = end_pos
    piece.first_move = false
  end

  def valid_move?(start_pos, end_pos)
    moves = self[*start_pos].valid_moves.include?(end_pos)
  end

  def [](row, col)
    @grid[row][col]
  end

  def []=(row, col, val)
    @grid[row][col] = val
  end

  def in_bounds?(position)
    y, x = position
    y.between?(0, 7) && x.between?(0, 7)
  end
end

class InvalidMove < StandardError
end

class NoPieceFound < StandardError
end
