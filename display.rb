require 'colorize'
require './board.rb'
require './player.rb'
require './game.rb'

class Display
  attr_accessor :cursor_pos, :selected_piece
  attr_reader :board

  def initialize(board)
    @board = board
    @cursor_pos = [7,0]
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
    elsif @selected_piece && @selected_piece.valid_moves.include?([row, col])
      bg = :light_magenta
    elsif @selected_piece && @selected_piece.position == [row, col]
      bg = :light_magenta
    elsif @board[*@cursor_pos].valid_moves.include?([row, col])
      bg = :yellow
    elsif (row + col).odd?
      bg = :light_blue
    else
      bg = :red
    end
    piece_color = @board[row, col].color
    {background: bg, color: piece_color}
  end

  def render(current_player)
    grid = build_grid
    system('clear')
    grid.each {|row| puts row.join }
    puts "#{current_player.name}'s turn"
    puts "White is in check!" if @board.check?(:white)
    puts "Black is in check!" if @board.check?(:black)
  end

end
