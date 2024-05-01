# frozen_string_literal: true

require "test_helper"

class TestGame < Minitest::Test
  def setup
    @game = VelhaEngine::Game.new
  end

  def test_create_new_game
    assert_kind_of VelhaEngine::Game, @game
  end

  def test_game_has_two_players
    assert_equal 2, @game.players.length
  end

  def test_game_starts_with_o
    assert_equal :o, @game.current_player
  end

  def test_game_has_empty_board
    @game.board.each do |cell|
      assert_nil cell
    end
  end

  def test_get_cell_value
    # setup
    @game.instance_variable_set(:@board, [:o, nil, nil,
                                          nil, :x, nil,
                                          nil, :o, nil])

    assert_equal :o, @game.cell_at(0, 0)
    assert_equal :x, @game.cell_at(1, 1)
    assert_equal :o, @game.cell_at(2, 1)
    assert_nil @game.cell_at(2, 2)
  end

  def test_play
    @game.play(0, 2)

    assert_equal :o, @game.cell_at(0, 2)
    assert_equal :x, @game.current_player

    @game.play(1, 2)

    assert_equal :x, @game.cell_at(1, 2)
    assert_equal :o, @game.current_player
  end

  def test_play_on_filled_cell
    @game.play(1, 2)

    assert_raises(VelhaEngine::InvalidPlayError) { @game.play(1, 2) }
  end

  def test_play_out_of_bounds
    assert_raises(VelhaEngine::OutOfBoardError) { @game.play(3, 0) }
    assert_raises(VelhaEngine::OutOfBoardError) { @game.play(0, 3) }
  end

  def test_player_win_line
    # :o              :x
    @game.play(0, 0); @game.play(1, 0)
    @game.play(0, 1); @game.play(1, 1)
    @game.play(0, 2)

    assert_predicate @game, :ended?
    assert_equal :o, @game.winner
  end

  def test_player_win_column
    # :o              :x
    @game.play(1, 0); @game.play(0, 2)
    @game.play(1, 1); @game.play(1, 2)
    @game.play(0, 0); @game.play(2, 2)

    assert_predicate @game, :ended?
    assert_equal :x, @game.winner
  end

  def test_player_win_diag
    # :o              :x
    @game.play(0, 0); @game.play(0, 2)
    @game.play(1, 1); @game.play(1, 2)
    @game.play(2, 2)

    assert_predicate @game, :ended?
    assert_equal :o, @game.winner
  end

  def test_player_win_reverse_diag
    # :o              :x
    @game.play(0, 0); @game.play(0, 2)
    @game.play(0, 1); @game.play(1, 1)
    @game.play(2, 2); @game.play(2, 0)

    assert_predicate @game, :ended?
    assert_equal :x, @game.winner
  end

  def test_play_after_ended
    # :o              :x
    @game.play(0, 0); @game.play(0, 2)
    @game.play(1, 1); @game.play(1, 2)
    @game.play(2, 2)

    assert_predicate @game, :ended?
    assert_raises(VelhaEngine::GameAlreadyEndedError) { @game.play(2, 1) }
  end
end
