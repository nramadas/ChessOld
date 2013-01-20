require './lib/pieces.rb'

class Player
  attr_accessor :pieces_remaining, :player_name

  def initialize(player_name, player_type)
    @player_name = player_name
    @pieces_remaining = []
    add_pawns(player_type)
    add_rooks(player_type)
    add_knights(player_type)
    add_bishops(player_type)
    add_king(player_type)
    add_queen(player_type)
  end

  def add_pawns(player_type)
    row = (player_type == :player1) ? 1 : 6

    (0...8).each do |col|
      @pieces_remaining << Pawn.new([row, col], player_type)
    end
  end

  def add_rooks(player_type)
    row = (player_type == :player1) ? 0 : 7

    [0, 7].each do |col|
      @pieces_remaining << Rook.new([row, col], player_type)
    end
  end

  def add_knights(player_type)
    row = (player_type == :player1) ? 0 : 7

    [1, 6].each do |col|
      @pieces_remaining << Knight.new([row, col], player_type)
    end
  end

  def add_bishops(player_type)
    row = (player_type == :player1) ? 0 : 7

    [2, 5].each do |col|
      @pieces_remaining << Bishop.new([row, col], player_type)
    end
  end

  def add_king(player_type)
    row = (player_type == :player1) ? 0 : 7

    @pieces_remaining << King.new([row, 4], player_type)
  end

  def add_queen(player_type)
    row = (player_type == :player1) ? 0 : 7

    @pieces_remaining << Queen.new([row, 3], player_type)
  end

  def get_move
    puts "Enter your move (ex: a2 a4):"
    print "> "
    input = gets.chomp.downcase.split
    return input if input == ["s"]
    return input if input == ["l"]
    move = []
    input.each do |coord|
      # Note, we use rows, cols. But in chess notation, cols comes first
      # Here, we switch them.
      move << [(1..8).to_a.reverse.index(coord[1].to_i),
              ('a'..'h').to_a.index(coord[0])]
    end
    move
  end
end