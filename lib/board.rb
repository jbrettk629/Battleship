class Board

  ATTACKING = {nil => "_", :s => "_", :x => "X", :o => "O"}
  SETTING = {nil => "_", :s => :s, :x => "X", :o => "O"}
  attr_reader :grid, :locations, :enemy_ships_remaining, :current_player

  def initialize(grid = self.class.default_grid)#, random = false)
    @grid = grid
    #populate if random
    @locations = {"carrier" => [], "battleship" => [],
      "submarine" => [], "destroyer" => [], "patrol" => []}
    @enemy_ships_remaining = ["carrier", "battleship", "submarine", "destroyer", "patrol"]
  end

  def self.default_grid
    Array.new(10) {Array.new(10)}
  end

  def ship_locations(ship, coordinates)
    @locations[ship] = coordinates
  end

  def remaining_ships
    puts "You still need to sink the following ships: #{@enemy_ships_remaining}"
  end

  def place_ship(ship)
    @locations[ship].each {|coordinate| set_ship(coordinate) }
  end

  def sunk?
    sunk = nil
    @enemy_ships_remaining.each do |ship|
      coordinates = @locations[ship]
      if coordinates.all? {|coordinate| self[coordinate] == :x}
        puts "You sunk the #{ship}!"
        @enemy_ships_remaining.delete(ship)
        sunk = true
      end
    end
    sunk
  end

  def [](pos)
    row = pos[0]
    col = pos[1]
    @grid[row][col]
  end

  def []=(pos, mark)
    row = pos[0]
    col = pos[1]
    @grid[row][col] = mark
  end

  def count
    @enemy_ships_remaining.count
  end

  def valid_shot?(pos)
    if self[pos] == nil || self[pos] == :s
      return true
    end
    false
  end

  def empty?(pos = nil)
    if pos == nil
      if @grid.flatten.all? {|space| space == nil}
        return true
      else
        return false
      end
    end
    row = pos.first
    col = pos.last
    if @grid[row][col] == nil
      true
    else
      false
    end
  end

  def ok_attack?(pos)
    row = pos.first
    col = pos.last
    if @grid[row][col] == nil || @grid[row][col] == :s
      true
    else
      false
    end
  end

  def size
    @grid.length
  end

  def random_pos
    [rand(size), rand(size)]
  end

  def set_ship(pos)
    self[pos] = :s
  end

  def won?
    return true if self.count == 0
    false
  end

  def convert_attack_row(row)
    converted = []
    row.each {|space| converted << ATTACKING[space]}
    converted
  end

  def converted_setting_row(row)
    converted = []
    row.each {|space| converted << SETTING[space]}
    converted
  end

  def render
    puts "YOUR OPPONENTS FLEET"
    display_grid = []
    @grid.each {|row| display_grid << convert_attack_row(row)}
    puts "  0 1 2 3 4 5 6 7 8 9"
    display_grid.each_with_index { |row,i| puts "#{i} "+row.join(" ")}
  end

  def show_ships
    puts "YOUR FLEET"
    display_grid = []
    @grid.each {|row| display_grid << converted_setting_row(row)}
      puts "  0 1 2 3 4 5 6 7 8 9"
    display_grid.each_with_index {|row, i| puts "#{i} "+row.join(" ")}
  end
end
