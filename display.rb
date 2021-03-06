require_relative 'board'
require_relative 'cursor'
require_relative 'pieces'
require 'colorize'

SYMBOL_MAP = {
  "Pawn" => ' ♟ ',
  "Rook" => ' ♜ ',
  "Bishop" => ' ♝ ',
  "Knight" => ' ♞ ',
  "Queen" => ' ♛ ',
  "King" => ' ♚ ',
  "Null" => '   '
}


class Display
  attr_reader :board, :cursor
  attr_accessor :notifications

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0,0], board)
    @notifications = {}
  end

  def render
    system "clear"
    puts "Arrow keys, WASD, or vim to move, space or enter to confirm."
    @board.rows.each_index do |row_ind|
      @board.rows[row_ind].each_index do |square_ind|
        #get the right char from the symbol map
        piece = @board[row_ind, square_ind]
        piece_color = piece.color == "black" ? :black : :white
        piece_sym = SYMBOL_MAP[piece.name]
        # set the symbol for the colorize method
        (row_ind + square_ind) % 2 == 0 ? back_color = :blue : back_color = :red
        # #render time
        if [row_ind,square_ind] == @cursor.cursor_pos
          if @cursor.selected
            back_color = :yellow
          else
            back_color = :green
          end
        end

        print piece_sym.colorize(:color => piece_color, :background => back_color)
      end
      print "\n"
    end
    @notifications.each do |_key, val|
      puts val
    end

    return nil
  end

  def set_check!
    @notifications[:check] = "Check!"
  end

  def uncheck!
    @notifications.delete(:check)
  end

  def reset!
    @notifications.delete(:error)
  end

end

# if $PROGRAM_NAME == __FILE__
# system "clear"
# display = Display.new(Board.new)
# display.render
# while display.cursor.cursor_pos != [7,7]
#   display.cursor.get_input
#   system "clear"
#   display.render
# end
# puts "the test is over"
# end
