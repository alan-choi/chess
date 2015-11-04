require './board.rb'
require './player.rb'
require './display.rb'

class Game
  attr_reader :board, :current_player

  def initialize(player1, player2)
    @board = Board.new
    @display = Display.new(@board)
    @current_player = Player.new(player1, @board, @display, :white)
    @other_player = Player.new(player2, @board, @display, :black)
  end

  def play
    until @board.over?
      @display.render(@current_player)
      input = @current_player.get_input

      until input == :move_made
        @display.render(@current_player)
        input = @current_player.get_input
        return if input == :exit
        return save if input == :save
      end
      switch_players
    end

    puts "#{@other_player.name} has won!"
  end

  def switch_players
    @current_player, @other_player = @other_player, @current_player
  end

  def save
    File.write("saved_game.yaml", self.to_yaml)
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new("player1", "player2")
  game.play
  # YAML.load_file(ARGV.shift).play
end
