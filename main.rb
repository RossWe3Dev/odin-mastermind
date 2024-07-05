class Game
  COLORED_PEGS = [:blue, :orange, :green, :purple, :yellow, :pink].freeze
  RIGHT_COLOR = :red
  RIGHT_POSITION_and_COLOR = :white

  attr_reader :secret_code, :name

  def initialize(name)
    @secret_code = Array.new(4) { COLORED_PEGS.sample }
    @player_name = name
  end

  def player_input
    puts "Please pick 4 pegs from [blue, orange, green, purple, yellow, pink]"
    input = gets.chomp.split().map{|color| color.to_sym }
    if input.all? { |chosen_pegs| COLORED_PEGS.include?(chosen_pegs) } && input.length == 4
      return puts "Good! #{input}"
    else
      puts "Invalid #{input}"
      player_input
    end
  end
end

master = Game.new('ross')
p master.secret_code
master.player_input
