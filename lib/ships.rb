
class Ships
  attr_reader :ships
    def initialize
      @ships = { "carrier" => [:s, :s, :s, :s, :s,], "battleship" => [:s, :s, :s, :s],
        "submarine" => [:s, :s, :s], "destroyer" => [:s, :s, :s], "patrol" => [:s, :s]}
    end

    def fit?(ship, pos, direction, current_board)
      #pos is an array
      if direction == "right"
        return false if (pos[1] + (ships[ship].length-1)) > 9
        horiz_coordinates(pos, ship).each {|space| return false if current_board[space] == :s}
      elsif direction == "down"
        return false if (pos[0] + (ships[ship].length-1)) > 9
        vert_coordinates(pos, ship).each {|space| return false if current_board[space] == :s}
      end
    end

    def ship_coordinates(ship, pos, direction, current_board)
       if direction == "right"
         coordinates = horiz_coordinates(pos, ship)
      elsif direction == "down"
         coordinates = vert_coordinates(pos, ship)
      end
      current_board.ship_locations(ship, coordinates)
    end

    def vert_coordinates(pos, ship)
      row = pos.first
      col = pos.last
      coordinates = []
      ships[ship].each_index do |idx|
         coordinates << [row + idx, col]
      end
      coordinates
    end

    def horiz_coordinates(pos, ship)
      row = pos.first
      col = pos.last
      coordinates = []
      ships[ship].each_index do |idx|
        coordinates << [row, col + idx]
      end
      coordinates
    end

  end
