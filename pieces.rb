module CalculateMoves
  # def move_knight(start_coord)

  # end

  # def move_pawn(start_coord)
  #   move_straight(start_coord, true) + move_diagonal(start_coord, true)
  # end

  # def move_king(start_coord)
end

class Piece
  attr_reader :token
  attr_accessor :captured, :coordinates, :player_type

  #include CalculateMoves

  def initialize(coordinates, player_type)
    @coordinates, @player_type = coordinates, player_type
    @captured = false
    @token = ""
  end

  private

  def move_straight(start_coord, once = false)
    possible_moves = []
    row, col = start_coord

    [[-1,0],[1,0],[0,-1],[0,1]].each do |pair|
      move = { :coord => start_coord, :prev_move => nil }
      x,y = row,col
      until (x + pair[0] < 0 || x + pair[0] > 7 ||
              y + pair[1] < 0 || y + pair[1] > 7)
        temp = move
        move = { :coord => [x + pair[0], y + pair[1]],
                            :prev_move => temp }
        possible_moves << move
        x,y = x+pair[0], y+pair[1]
        break if once
      end
    end
    possible_moves
  end

  def move_diagonal(start_coord, once = false)
    possible_moves = []
    row, col = start_coord

    [[-1,-1],[-1,1],[1,-1],[1,1]].each do |pair|
      move = { :coord => start_coord, :prev_move => nil }
      x,y = row,col
      until (x + pair[0] < 0 || x + pair[0] > 7 ||
              y + pair[1] < 0 || y + pair[1] > 7)
        temp = move
        move = { :coord => [x + pair[0], y + pair[1]],
                            :prev_move => temp }
        possible_moves << move
        x,y = x+pair[0], y+pair[1]
        break if once
      end
    end
    possible_moves
  end

end

class Pawn < Piece
  attr_accessor :moved

  def initialize(coordinates, player_type)
    super
    @token = "\u2659"
    @made_first_move = false
  end

  def get_moves
    move_straight(@coordinates, true) + move_diagonal(@coordinates, true)
  end

end

class Rook < Piece
  attr_accessor :moved

  def initialize(coordinates, player_type)
    super
    @token = "\u2656"
    @made_first_move = false
  end

  def get_moves
    move_straight(@coordinates)
  end

end

class Bishop < Piece
  def initialize(coordinates, player_type)
    super
    @token = "\u2657"
  end

  def get_moves
    move_diagonal(@coordinates)
  end

end

class Knight < Piece
  def initialize(coordinates, player_type)
    super
    @token = "\u2658"
  end

  def get_moves
    possible_moves = []
    row, col = @coordinates
    move = { :coord => @coordinates, :prev_coord => nil }

    [[-1,-2],[-2,-1],[-2,1],[-1,2],[1,2],[2,1],[2,-1],[1,-2]].each do |pair|
      unless (row + pair[0] < 0 || row + pair[0] > 7 ||
              col + pair[1] < 0 || col + pair[1] > 7)
        possible_moves << { :coord => [row + pair[0], col + pair[1]], 
                            :prev_move => move}
      end
    end
    possible_moves
  end

end

class King < Piece
  attr_accessor :moved

  def initialize(coordinates, player_type)
    super
    @token = "\u2654"
    @made_first_move = false
  end

  def get_moves
    move_straight(@coordinates, true) + move_diagonal(@coordinates, true)
  end

end

class Queen < Piece
  def initialize(coordinates, player_type)
    super
    @token = "\u2655"
  end

  def get_moves
    move_straight(@coordinates) + move_diagonal(@coordinates)
  end

end