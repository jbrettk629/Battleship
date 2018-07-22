require_relative "board"
require_relative "player"
require_relative "computer"
require_relative "ships"

class BattleshipGame
  attr_accessor :p1_board, :player1, :player2, :p2_board, :current_player

  def initialize(player1 = HumanPlayer.new, p1_board = Board.new, ships = Ships.new)
    @player1 = player1
    @p1_board = p1_board
    @player2
    @p2_board
    @current_player = player1
    @current_board = p1_board
    @ships = ships
  end

  def switch_player
    if @current_player == player1
      @current_player = player2
    else
      @current_player = player1
    end
  end

  def switch_board
    if @current_board == p1_board
      @current_board = p2_board
    else
      @current_board = p1_board
    end
  end

  def what_version
    puts "How many players? Ex: 1 (play against comp) or 2 (play against friend)"
    version = gets.chomp
    if version == "1"
      @player2 = CompPlayer.new
      @p2_board = Board.new
    else
      @player2 = HumanPlayer.new
      @p2_board = Board.new
    end
    version
  end

  def setup_single_player
    puts "-------SETUP FOR PLAYER 1}---------"
    get_name
    @current_player.set_ships(@current_board, @ships)
    switch_player
    switch_board
    clear_screen
    @current_player.set_ships(@current_board,@ships)
  end

  def setup_two_player
      player = 1
      2.times do
        puts "-------SETUP FOR PLAYER #{player}---------"
        get_name
        @current_player.set_ships(@current_board, @ships)
        switch_player
        switch_board
        player = 2
        clear_screen
    end
  end


  def get_name
    puts "What is your name, Admiral?"
    submission = gets.chomp
    current_player.name = submission.capitalize
  end

  def welcome
    puts "-------BATTLESHIP-------"
    3.times {puts "\n"}
    puts "Prepare for War!"
    4.times {puts "\n"}
  end

  def play
    clear_screen
    welcome
    version = what_version
    clear_screen
    if version == "1"
      setup_single_player
    else
      setup_two_player
    end
    @current_player = player1
    @current_board = p2_board
    while true
      play_turn
      break if game_over?
      switch_board
      switch_player
    end
    puts "Congratulations #{@current_player.name}, you won!"
    5.times {puts "\n"}
    puts "Hit 'Enter' to close the game"
    gets.chomp
  end

  def play_turn
    player_ready? if @current_player.class == HumanPlayer
    @current_board.remaining_ships
    display_status
    pos = @current_player.get_play(@current_board)
    hit_or_miss(pos)
    attack(pos)
    sunk = @current_board.sunk?
    puts "sunk value is #{sunk}"
    if @current_player.class == CompPlayer && sunk == true
      @current_player.clear_attack_memory
    end
    puts "You have #{@current_board.count} ships remaining!"
    player_finished? if @current_player.class == HumanPlayer
  #  switch_player
  #  switch_board
    clear_screen
  end

  def player_ready?
    puts "-------------------"
    puts "Press Enter when you are ready to start your turn"
    ready = gets.chomp
  end

  def player_finished?
    puts "-------------------"
    puts "Press Enter to set up next turn"
    ready = gets.chomp
  end

  def hit_or_miss(pos)
    if @current_board[pos] == :s
      puts "It's a hit!"
    else
      puts "It's a miss!"
    end
  end


  def attack(pos)
    if @current_board[pos] == :s
      @current_board[pos] = :x
      @current_player.remember_strikes(pos) if current_player.class == CompPlayer
    else
      @current_board[pos] = :o
    end
  end

  def display_status
    switch_board
    @current_board.show_ships
    puts "----------------------"
    puts "----------------------"
    switch_board
    @current_board.render
  end

  def count
    @current_board.count
  end

  def game_over?
    @current_board.won?
  end

  def clear_screen
    system('clear')
  end
end

if __FILE__ == $PROGRAM_NAME
  BattleshipGame.new.play
end
