class Game
  COLORED_PEGS = %i[blue orange green purple yellow pink].freeze
  RIGHT_COLOR = :red
  RIGHT_POSITION_AND_COLOR = :white

  attr_reader :secret_code, :name

  def initialize(name)
    @secret_code = Array.new(4) { COLORED_PEGS.sample }
    @player_name = name
  end

  def player_input
    puts "Please pick 4 pegs from [blue, orange, green, purple, yellow, pink]"
    input = gets.chomp.split.map(&:to_sym)
    until input.all? { |chosen_pegs| COLORED_PEGS.include?(chosen_pegs) } && input.length == 4
      puts "Invalid #{input}"
      player_input
    end
    puts "Good! #{input}"
  end
end

master = Game.new("Odin")
p master.secret_code
master.player_input
