require_relative 'board'
require_relative 'player'

class Game
  attr_reader :board, :display, :players, :current_player

  def initialize
    @board = Board.new
    @display = Display.new(board)
    @players = {1 => HumanPlayer.new('black',display), 2 => HumanPlayer.new('white',display)}
    @current_player = 1
  end

  def play
    until board.checkmate?(@players[current_player].color)
      begin
       start_pos, end_pos = @players[current_player].make_move(board)
       board.move_piece(start_pos, end_pos, @players[current_player].color)
       swap_turn!
       notify_players
      rescue StandardError => e
        @display.notifications[:error] = e.message
        retry
      end
    end
    display.render
    puts "#{@players[current_player].color} is checkmated."
    nil
  end

  private

  def notify_players
    if board.in_check?(@players[current_player].color)
      display.set_check!
    else
      display.uncheck!
    end
  end

  def swap_turn!
    @current_player = current_player == 1 ? 2 : 1
  end


end

if $PROGRAM_NAME == __FILE__
  Game.new.play
end
