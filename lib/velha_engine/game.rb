# frozen_string_literal: true

module VelhaEngine
  class OutOfBoardError < Error; end
  class GameAlreadyEndedError < Error; end
  class InvalidPlayError < Error; end

  # Game defines the main class of VelhaEngine. This allows creating new games.
  # The game comes pre populated with two players: :o, and :x.
  class Game
    SIZE = 3

    attr_reader :players, :board

    def initialize
      @players = %i[o x]
      @board = Array.new(SIZE * SIZE)
    end

    def current_player
      players.first
    end

    def cell_at(x, y)
      @board[pos(x, y)]
    end

    def play(x, y)
      raise OutOfBoardError if x >= SIZE || y >= SIZE
      raise GameAlreadyEndedError if ended?

      cell_value = @board[pos(x, y)]
      raise InvalidPlayError if cell_value

      @board[pos(x, y)] = current_player
      players.reverse!
      nil
    end

    def ended?
      line_winner? || column_winner? || diagonal_winner?
    end

    def winner
      ended? && players.last
    end

    def debug_print
      puts @board[0..2].join(" | ")
      puts @board[3..5].join(" | ")
      puts @board[6..8].join(" | ")
    end

    private

    def pos(x, y)
      (x * SIZE) + y
    end

    def line_winner?
      @board
        .each_slice(3)
        .map do |line|
          line.uniq.size == 1 && players.include?(line.first)
        end
        .include?(true)
    end

    def column_winner?
      (0...SIZE).map do |c|
        col = (0...SIZE).map { |l| @board[pos(l, c)] }
        col.uniq.size == 1 && players.include?(col.first)
      end.include?(true)
    end

    def diagonal_winner?
      [
        (0...SIZE).map { |i| @board[pos(i, i)] },
        (0...SIZE).map { |i| @board[pos(i, SIZE - i - 1)] }
      ].map do |diag|
        diag.uniq.size == 1 && players.include?(diag.first)
      end.include?(true)
    end
  end
end
