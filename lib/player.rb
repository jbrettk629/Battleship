require_relative "board"


class HumanPlayer

  attr_accessor :name, :available_ships

  def initialize
    @name = name
    @available_ships = ["carrier", "battleship",
         "submarine", "destroyer", "patrol"]
  end

  def get_play(board)
    while true
      puts "Admiral #{name}, where would you like to attack? Ex: 1,2"
      pos = gets.chomp.split(",").map {|el| el.to_i}
      break if ok_move?(pos, board)
    end
    pos
  end

  def valid_entry?(pos)
    ##assumes a 10x10 board
    if pos.length == 2
       return true if pos.all? {|num| (0..9).include?(num)}
    end
    false
  end

  def ok_move?(pos, current_board)
    if valid_entry?(pos) == false
      puts "That is not a valid entry, try again!"
      return false
    end
    if current_board.valid_shot?(pos) == false
      puts "You've already gone there, pick again!"
      return false
    end
    true
  end

  def choose_starting_pos(ship, current_board)
    puts "You have selected your #{ship}!"
    puts "Choose a coordinate to start your ship on(Ex: 1,2). You will then be asked
    what direction you want the rest of the ship to go. You'll only be able
      to choose 'right' or 'down', so keep that in mind!)"
      while true
        pos = gets.chomp.split(",").map {|el| el.to_i}
        break if ok_move?(pos, current_board)
      end
    puts "\n"
    pos
  end

  def choose_direction(pos)
    puts "You have selected #{pos} as the starting point of your ship."
    puts "What direction do you want the rest of the ship to go? (Down or Right)"
    while true
      direction = gets.chomp(&:downcase)
      break if direction == "down" || direction == "right"
      puts "Oops! You can only pick Down or Right! Try again!"
    end
    puts "\n"
    direction
  end

  def choose_ship(available_ships)
    while true
      puts "What ship would you like to place? (Ex: carrier)"
      ship = gets.chomp(&:downcase)
      break if available_ships.include?(ship.to_s)
      puts "Something wasn't right, try again!"
    end
    puts "\n"
    ship
  end

  def remove_option(ship, available_ships)
    @available_ships.shift
    available_ships.select! {|k,v| k != ship}
  end


  def set_ships(current_board, ships)
   available_ships = {"carrier" => "5 spaces", "battleship" => "4 spaces",
       "submarine" => "3 spaces", "destroyer" => "3 spaces", "patrol" => "2 spaces"}
       while true
         puts "Available Ships: #{available_ships}"
         current_board.show_ships
         ship = choose_ship(available_ships)
         pos = choose_starting_pos(ship, current_board)
         direction = choose_direction(pos)
         if ships.fit?(ship, pos, direction, current_board) == false
           puts "That ship won't fit there, try again!"
           next
        end
        ships.ship_coordinates(ship, pos, direction, current_board)
        current_board.place_ship(ship)
        remove_option(ship, available_ships)
        clear_screen
        break if available_ships.empty?
      end
    end

  def clear_screen
    system('clear')
  end

end
