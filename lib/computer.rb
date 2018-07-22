require_relative "board"

class CompPlayer

 attr_accessor :orig_strike, :follow_up_shot, :attack_direction,
  :available_ships, :name
 attr_reader :current_board


  def initialize
    @name = "Computer"
    @available_ships = ["carrier", "battleship",
         "submarine", "destroyer", "patrol"]
    @orig_strike = nil
    @follow_up_shot = nil
    @attack_direction = nil
  end

  def remove_option(ship)
    @available_ships.shift
  end

  def set_ships(current_board, ships)
       while true
         ship = @available_ships.first
         pos = random_pos
         direction = ["right", "down"].sample
         if ships.fit?(ship, pos, direction, current_board) == false
           next
         end
         ships.ship_coordinates(ship, pos, direction, current_board)
         current_board.place_ship(ship)
         remove_option(ship)
         break if available_ships.empty?
       end
    end

    def get_play(current_board)
      return get_random_play(current_board) if orig_strike == nil
      return get_smart_play(current_board)
    end

  def get_random_play(current_board)
    while true
      pos = random_pos
      return pos if ok_attack?(pos, current_board)
    end
  end

  def get_smart_play(current_board)
    pos = nil
    until pos != nil
      pos = not_random_pos(current_board) if @attack_direction == nil
      pos = horiz_attack(current_board) if @attack_direction == "horiz"
      pos = vert_attack(current_board) if @attack_direction == "vert"
    end
    pos
  end

  def random_pos
    return [Random.new.rand(0..9), Random.new.rand(0..9)]
  end

  def ok_placement?(pos, current_board)
    if current_board.empty?(pos) && valid_move?(pos)
      return true
    end
    false
  end

  def ok_attack?(pos, current_board)
    if  valid_move?(pos) && current_board.ok_attack?(pos)
       true
    else
      false
    end
  end

  def not_random_pos(current_board)
    row = orig_strike[0]
    col = orig_strike[1]
    surrounding_spaces = [[row-1, col], [row+1, col], [row, col+1], [row, col-1]]
    surrounding_spaces.each do |space|
      return space if ok_attack?(space, current_board)
    end
  end

  def horiz_attack(current_board)
    if follow_up_shot != nil
      col = follow_up_shot[1]
      row = follow_up_shot[0]
      return [row, col - 1] if ok_attack?([row, col - 1], current_board)
      return [row, col + 1] if ok_attack?([row, col + 1], current_board)
    end
    col = orig_strike[1]
    row = orig_strike[0]
    return [row, col - 1] if ok_attack?([row, col - 1], current_board)
    return [row, col + 1] if ok_attack?([row, col + 1], current_board)
    change_attack_strategy
  end

  def vert_attack(current_board)
    if follow_up_shot != nil
      col = follow_up_shot[1]
      row = follow_up_shot[0]
      return [row - 1, col] if ok_attack?([row - 1, col], current_board)
      return [row + 1, col] if ok_attack?([row + 1, col], current_board)
    end
    col = orig_strike[1]
    row = orig_strike[0]
    return [row - 1, col] if ok_attack?([row - 1, col], current_board)
    return [row + 1, col] if ok_attack?([row + 1, col], current_board)
    change_attack_strategy
  end

  def set_strategy
    @attack_direction = "horiz" if @orig_strike[0] == @follow_up_shot[0]
    @attack_direction = "vert" if @orig_strike[1] == @follow_up_shot[1]
  end

  def change_attack_strategy
    follow_up_shot = nil
    if @attack_direction == "vert"
      @attack_direction = "horiz"
    else
      @attack_direction = "vert"
    end
  end

  def remember_strikes(pos)
    if @orig_strike == nil
      @orig_strike = pos
    else
      @follow_up_shot = pos
      set_strategy
    end
  end

  def clear_attack_memory
    @attack_direction = nil
    @orig_strike = nil
    @follow_up_shot = nil
  end

  def poss_direction?
    @attack_direction = "horiz" if orig_strike[0] == follow_up_shot[0]
    @attack_direction = "vert" if orig_strike[1] == follow_up_shot[1]
  end

  def valid_move?(pos)
    row = pos[0]
    col = pos[1]
    return false unless (0..9).include?(row)
    return false unless (0..9).include?(col)
    true
  end


end
