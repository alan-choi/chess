require 'colorize'
load './board.rb'

class Display
  attr_reader :board

  def initialize(board)
    @board = board
    @cursor_pos = [0,0]
    @selected = false
  end

  def build_grid
    board.grid.map.with_index do |row, row_idx|
      row.map.with_index do |piece, col_idx|
        color_options = colors_for(row_idx, col_idx)
        piece.to_s.colorize(color_options)
      end
    end
  end

  def colors_for(row, col)
    if [row, col] == @cursor_pos
      bg = :green
    elsif @board[*@cursor_pos].valid_moves.include?([row, col])
      bg = :yellow
    elsif @selected_piece && @selected_piece.valid_moves.include?([row, col])
      bg = :yellow
    elsif (row + col).odd?
      bg = :light_blue
    else
      bg = :light_red
    end
    piece_color = @board[row, col].color
    {background: bg, color: piece_color}
  end

  def render

    while (true)
      system('clear')
      build_grid.each {|row| puts row.join }
      break if move_cursor == :exit
    end

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

  def move_cursor
    c = read_char
    y, x = @cursor_pos

    case c
    when "\e[A" # Up
      @cursor_pos = [(y - 1) % 8, x]
    when "\e[B" # Down
      @cursor_pos = [(y + 1) % 8, x]
    when "\e[C" # Right
      @cursor_pos = [y, (x + 1) % 8]
    when "\e[D" # Left
      @cursor_pos = [y, (x - 1) % 8]
    when "\r"
      return :exit
    when " "
      if @selected_piece.nil?
        @selected_piece = @board[*@cursor_pos]
      elsif @selected_piece.position == @cursor_pos
        @selected_piece = nil
      else
        @board.move_piece(@selected_piece.position, @cursor_pos)
        @selected_piece = nil
      end
    end
    rescue NoPieceFound
      puts "No Piece Found"
      @selected_piece = nil
      retry
    rescue InvalidMove
      puts "Invalid Move"
      @selected_piece = nil
      retry
  end

end
