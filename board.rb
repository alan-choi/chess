load './piece.rb'

class Board
  ROOKS = [[0,0], [0,7], [7,0], [7,7]]
  KNIGHTS = [[0,1], [0,6], [7,1], [7,6]]
  BISHOPS = [[0,2], [0,5], [7,2], [7,5]]
  QUEENS = [[0,3], [7,3]]
  KINGS = [[0,4], [7,4]]


  attr_reader :grid
  def initialize
    @grid = Array.new(8) { Array.new(8) }
    populate_board
  end

  def populate_board
    8.times do |row_idx|
      8.times do |col_idx|
        @grid[col_idx][row_idx] = EmptySpace.new(self, [col_idx, row_idx])
      end
    end

    ROOKS.each { |pos| @grid[pos[0]][pos[1]] = Rook.new(self,pos)}
    KNIGHTS.each { |pos| @grid[pos[0]][pos[1]] = Knight.new(self,pos)}
    BISHOPS.each { |pos| @grid[pos[0]][pos[1]] = Bishop.new(self,pos)}
    QUEENS.each { |pos| @grid[pos[0]][pos[1]] = Queen.new(self,pos)}
    KINGS.each { |pos| @grid[pos[0]][pos[1]] = King.new(self,pos)}
    pawn_positions.each { |pos| @grid[pos[0]][pos[1]] = Pawn.new(self,pos)}

  end

  def pawn_positions
    pawns = []
    8.times do |pawn_idx|
      pawns << [1, pawn_idx]
      pawns << [6, pawn_idx]
    end
    pawns
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

  def []=(row, col, val)
    @grid[row][col] = val
  end

  def in_bounds?(position)
    y, x = position
    y.between?(0, 7) && x.between?(0, 7)
  end

end
