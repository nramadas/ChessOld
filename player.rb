require './pieces.rb'

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
    (0...8).each do |column|
      row = (player_type == :player1) ? 1 : 6
      @pieces_remaining << Pawn.new([row,column], player_type)
    end
  end

  def add_rooks(player_type)
    [0,7].each do |column|
      row = (player_type == :player1) ? 0 : 7
      @pieces_remaining << Rook.new([row,column], player_type)
    end
  end

  def add_knights(player_type)
    [1,6].each do |column|
      row = (player_type == :player1) ? 0 : 7
      @pieces_remaining << Knight.new([row,column], player_type)
    end
  end

  def add_bishops(player_type)
    [2,5].each do |column|
      row = (player_type == :player1) ? 0 : 7
      @pieces_remaining << Bishop.new([row,column], player_type)
    end
  end

  def add_king(player_type)
    row = (player_type == :player1) ? 0 : 7
    @pieces_remaining << King.new([row,4], player_type)
  end

  def add_queen(player_type)
    row = (player_type == :player1) ? 0 : 7
    @pieces_remaining << Queen.new([row,3], player_type)
  end

end