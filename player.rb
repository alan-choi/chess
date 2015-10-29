require './display.rb'
require './board.rb'
require './game.rb'

class Player
  attr_reader :name, :color

  def initialize(name, board, display, color)
    @name = name
    @board = board
    @display = display
    @color = color
  end

  def read_char
    STDIN.echo = false
    STDIN.raw!

    input = STDIN.getc.chr
    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
  ensure
    STDIN.echo = true
    STDIN.cooked!

    return input
  end

  def get_input
    c = read_char
    y, x = @display.cursor_pos

    case c
    when "\e[A" # Up
      @display.cursor_pos = [(y - 1) % 8, x]
    when "\e[B" # Down
      @display.cursor_pos = [(y + 1) % 8, x]
    when "\e[C" # Right
      @display.cursor_pos = [y, (x + 1) % 8]
    when "\e[D" # Left
      @display.cursor_pos = [y, (x - 1) % 8]
    when "\r"
      return :exit
    when "s"
      return :save
    when " "
      player_selection
    end
    rescue NoPieceFound
      puts "No Piece Found"
      @display.selected_piece = nil
      retry
    rescue InvalidMove
      puts "Invalid Move"
      @display.selected_piece = nil
      retry
    rescue InvalidPiece
      puts "Cannot select your opponents pieces!"
      @display.selected_piece = nil
      retry
  end

  def player_selection

    if @display.selected_piece.nil? #if player selects empty space
      @display.selected_piece = @board[*@display.cursor_pos]
    elsif @display.selected_piece.position == @display.cursor_pos #deselects piece
      @display.selected_piece = nil
    else
      raise InvalidPiece if @display.selected_piece.color != self.color

      @board.move_piece(@display.selected_piece.position, @display.cursor_pos)
      @display.selected_piece = nil
      return :move_made
    end
  end

end

class InvalidPiece < StandardError
end
