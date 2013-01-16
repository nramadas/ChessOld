class Piece
  attr_reader :token
  attr_accessor :captured, :coordinates

  def initialize(coordinates)
    @coordinates = coordinates
    @captured = false
    @token = ""
  end

end

class Pawn < Piece
  def initialize
    super(coordinates)
    @token = "\u2659"
  end

end

class Rook < Piece
  def initialize
    super(coordinates)
    @token = "\u2656"
  end

end

class Bishop < Piece
  def initialize
    super(coordinates)
    @token = "\u2657"
  end

end

class Knight < Piece
  def initialize
    super(coordinates)
    @token = "\u2658"
  end

end

class King < Piece
  def initialize
    super(coordinates)
    @token = "\u2654"
  end

end

class Queen < Piece
  def initialize
    super(coordinates)
    @token = "\u2655"
  end

end