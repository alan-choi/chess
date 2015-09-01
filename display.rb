#require 'colorize'
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
        #color_options = colors_for(row_idx, col_idx)
        piece.to_s#.colorize(color_options)
      end
    end
  end

  def colors_for(i, j)
    if [i, j] == @cursor_pos
      bg = :green
    elsif (i + j).odd?
      bg = :light_blue
    else
      bg = :light_red
    end
    {background: bg, color: :white}
  end

  def render

    #puts 'fill the grid!'
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
    x,y = @cursor_pos

    case c
    when "\e[A" # Up
      @cursor_pos = [(x - 1) % 8, y]
    when "\e[B" # Down
      @cursor_pos = [(x + 1) % 8, y]
    when "\e[C" # Right
      @cursor_pos = [x, (y + 1) % 8]
    when "\e[D" # Left
      @cursor_pos = [x, (y - 1) % 8]
    when "\r"
      return :exit
    end

  end

end
