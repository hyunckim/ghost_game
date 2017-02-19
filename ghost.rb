
require 'set'
require 'pathname'

class Game

  attr_reader :dictionary, :players

  def initialize(players, dictionary)
    @players = players
    @dictionary = dictionary
    @fragment = ""
    @losses = Hash.new(0)
    @player_idx = 0
  end

  def next_player!
    @player_idx += 1
    @player_idx = 0 if @player_idx == @players.size
  end

  def current_player
    @players[@player_idx]
  end

  def run
    while @players.length > 1
      display_standings
      play_round
      reject_losing_player
    end
    puts "\n#{@players[0].name} won!"
  end

  def reject_losing_player
    losing_player = @players.select { |player| @losses[player] == 5 }[0]
    if losing_player
      puts "\n#{losing_player.name} is eliminated!"
      @players.reject! { |player| player == losing_player }
    end
  end

  def display_standings
    @players.each do |player|
      puts "#{player.name} has \"#{record(player)}\""
    end
  end

  def play_round
    @fragment = ""
    @player_idx = rand(players.size)
    loop do
      take_turn(current_player)
      if game_over?
        @losses[current_player] += 1
        puts "\n#{current_player.name} gained a letter by spelling #{@fragment.upcase}!"
        break
      else
        next_player!
      end
    end
  end

  def record(player)
    "GHOST"[0...@losses[player]]
  end

  def game_over?
    @dictionary.include?(@fragment)
  end

  def take_turn(player)
    move = player.guess(@fragment)
    until valid_play?(move)
      player.alert_invalid_guess
      move = player.guess(@fragment)
    end
    @fragment << move

  end

  def valid_play?(move)
    return false unless move.length == 1
    @dictionary.any? { |word| word.start_with?(@fragment + move) }
  end

end

class Player

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def alert_invalid_guess
    puts "Invalid choice!"
  end

  def guess(fragment)
    puts "\nCurrent state: \"#{fragment}\"", "#{name}, pick a letter."
    gets.chomp
  end

end

if __FILE__ == $PROGRAM_NAME
  path = Pathname.pwd + "dictionary.txt"
  dictionary = path.readlines.map(&:chomp)
  puts "How many people will play GHOST?"
  players = []
  num_players = gets.chomp.to_i
  num_players.times do |i|
    puts "Enter a name for player #{i + 1}"
    players << Player.new(gets.chomp)
  end
  Game.new(players, dictionary).run
end
