class Piece
  attr_reader :token
  attr_accessor :captured, :coordinates, :player_type

  def initialize(coordinates, player_type)
    @coordinates, @player_type = coordinates, player_type
    @captured = false
    @token = ""
  end

  private

  def move_straight(start_coord, times = 10)
    possible_moves = []
    row, col = start_coord

    [[-1,0],[1,0],[0,-1],[0,1]].each do |pair|
      move = { :coord => start_coord, :prev_move => nil }
      x,y = row,col
      do_counter = 0
      until (x + pair[0] < 0 || x + pair[0] > 7 ||
              y + pair[1] < 0 || y + pair[1] > 7)

        do_counter += 1

        temp = move
        move = { :coord => [x + pair[0], y + pair[1]],
                            :prev_move => temp }

        possible_moves << move
        x, y = x + pair[0], y + pair[1]

        break if do_counter == times
      end
    end
    possible_moves
  end

  def move_diagonal(start_coord, times = 10)
    possible_moves = []
    row, col = start_coord

    [[-1,-1],[-1,1],[1,-1],[1,1]].each do |pair|
      move = { :coord => start_coord, :prev_move => nil }
      x,y = row,col
      do_counter = 0
      until (x + pair[0] < 0 || x + pair[0] > 7 ||
              y + pair[1] < 0 || y + pair[1] > 7)

        do_counter += 1

        temp = move
        move = { :coord => [x + pair[0], y + pair[1]],
                            :prev_move => temp }

        possible_moves << move
        x, y = x + pair[0], y + pair[1]

        break if do_counter == times
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
    @coordinates_at_start = coordinates
  end

  def get_moves
    if @coordinates == @coordinates_at_start
      possible_moves = move_straight(@coordinates, 2) +
                      move_diagonal(@coordinates, 1)
    else
      possible_moves = move_straight(@coordinates, 1) +
                      move_diagonal(@coordinates, 1)
    end
    if @player_type == :player1
      possible_moves.delete_if { |move| move[:coord][0] <= @coordinates[0] }
    else
      possible_moves.delete_if { |move| move[:coord][0] >= @coordinates[0] }
    end
    possible_moves
  end

end

class Rook < Piece
  attr_accessor :moved

  def initialize(coordinates, player_type)
    super
    @token = "\u2656"
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
  end

  def get_moves
    move_straight(@coordinates, 1) + move_diagonal(@coordinates, 1)
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