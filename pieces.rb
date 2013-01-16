class Piece
  attr_reader :token
  attr_accessor :captured, :coordinates, :player_type

  def initialize(coordinates, player_type)
    @coordinates, @player_type = coordinates, player_type
    @captured = false
    @token = ""
  end

end

class Pawn < Piece
  def initialize(coordinates, player_type)
    super
    @token = "\u2659"
  end

end

class Rook < Piece
  def initialize(coordinates, player_type)
    super
    @token = "\u2656"
  end

end

class Bishop < Piece
  def initialize(coordinates, player_type)
    super
    @token = "\u2657"
  end

end

class Knight < Piece
  def initialize(coordinates, player_type)
    super
    @token = "\u2658"
  end

end

class King < Piece
  def initialize(coordinates, player_type)
    super
    @token = "\u2654"
  end

end

class Queen < Piece
  def initialize(coordinates, player_type)
    super
    @token = "\u2655"
  end

end