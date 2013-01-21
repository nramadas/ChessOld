class GameBoard
  attr_reader :board, :player1, :player2

  def initialize
    @board = Array.new(8) { Array.new(8) { nil } }
    @player1 = Player.new("1", :player1)
    @player2 = Player.new("2", :player2)
    build_board([@player1, @player2])
  end

  def build_board(players)
    players.each do |player|
      player.pieces_remaining.each do |piece|
        row, col = piece.coordinates

        @board[row][col] = piece
      end
    end
  end

  def load
    @player1 = YAML::load(File.read("./data/player1_save_check1"))
    @player2 = YAML::load(File.read("./data/player2_save_check1"))
    @board = Array.new(8) { Array.new(8) { nil } }
    build_board([@player1, @player2])
  end

  def print_board
    puts " \u2009 a  b  c  d  e  f  g  h"
    @board.each_with_index do |row, row_index|
      print "#{(1..8).to_a.reverse[row_index]} |"
      row.each_with_index do |piece, col_index|
        print "\u0332" unless col_index==0
        if piece.nil?
          print "  |"
        else
          if piece.player_type == :player1
            print piece.token.red
          else
            print piece.token.yellow
          end
          print " |"
        end
      end
      puts
    end
  end

  def execute_move(player, start_coord, end_coord)
    if valid_move?(player, start_coord, end_coord)

      # Make a copy of the current board
      File.open("./data/player1_exec", "w") { |f| f.write(@player1.to_yaml) }
      File.open("./data/player2_exec", "w") { |f| f.write(@player2.to_yaml) }

      # Grab what's in the start and end
      start_piece = @board[start_coord[0]][start_coord[1]]
      end_piece = @board[end_coord[0]][end_coord[1]]

      # If the end has an opponent's piece, get rid of it
      if other_player(player).pieces_remaining.include?(end_piece)
        other_player(player).pieces_remaining.delete(end_piece)
      end

      # Move the piece
      @board[start_coord[0]][start_coord[1]] = nil
      @board[end_coord[0]][end_coord[1]] = start_piece
      start_piece.coordinates = end_coord

      if check?(player)
        restore("./data/player1_exec", "./data/player2_exec")
        return false
      else
        return true
      end
    else
      return false
    end
  end

  def restore(file1, file2)
    @player1 = YAML::load(File.read(file1))
    @player2 = YAML::load(File.read(file2))
    @board = Array.new(8) { Array.new(8) { nil } }
    build_board([@player1, @player2])
  end

  def check?(player)
    king = player.pieces_remaining.select { |piece| piece.is_a?(King) }[0]
    opponent = other_player(player)
    opponent.pieces_remaining.select do |piece|
      valid_move?(opponent, piece.coordinates, king.coordinates)
    end.any?
  end

  def checkmate?(player)
    # Make a copy of the current board
    File.open("./data/player1_checkmate", "w") { |f| f.write(@player1.to_yaml) }
    File.open("./data/player2_checkmate", "w") { |f| f.write(@player2.to_yaml) }

    # Do every move possibility, and see if it clears the check
    player.pieces_remaining.each do |piece|
      piece.get_moves.each do |move|
        if execute_move(player, piece.coordinates, move[:coord])
          restore("./data/player1_checkmate", "./data/player2_checkmate")
          return false
        end
      end
    end

    restore("./data/player1_checkmate", "./data/player2_checkmate")
    true
  end

  def valid_move?(player, start_coord, end_coord)

    start_piece = @board[start_coord[0]][start_coord[1]]
    end_piece = @board[end_coord[0]][end_coord[1]]

    # Check that player owns the piece at the start_coord
    return false unless player.pieces_remaining.include?(start_piece)

    # Check that player doesn't own the piece at the end_coord
    return false if player.pieces_remaining.include?(end_piece)

    # Make sure that the piece can move in that way
    possible_moves = start_piece.get_moves

    move_to_eval = possible_moves.select { |move| move[:coord] == end_coord }[0]
    return false if move_to_eval.nil?

    # Special bit if piece is a Pawn
    if start_piece.is_a?(Pawn)
      if move_to_eval[:coord][1] != start_coord[1] # trying to move diagonally
        return false if end_piece.nil? # Just make sure a piece is there. We
        # already check that it isn't ours above
        return true
      else
        return path_clear?(move_to_eval[:prev_move]) if end_piece.nil?
        return false
      end
    end

    # Make sure that the path is clear for the piece to move
    return path_clear?(move_to_eval[:prev_move])
  end

  def path_clear?(move)
    row, col = move[:coord]

    if move[:prev_move].nil?
      return true
    elsif !@board[row][col].nil?
      return false
    else
      return path_clear?(move[:prev_move])
    end
  end

  def other_player(player)
    player == @player1 ? @player2 : @player1
  end
end