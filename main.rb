require "colorize"

class Game
  COLORED_PEGS = %i[blue orange green purple yellow pink].freeze
  RIGHT_COLOR = :red
  RIGHT_POSITION_AND_COLOR = :white

  attr_reader :secret_code, :name, :feedback

  def initialize(name)
    @secret_code = Array.new(4) { COLORED_PEGS.sample }
    @player_name = name
    @feedback = []
  end

  def play
    12.times do |num|
      puts "Attempt number #{num + 1}".colorize(:cyan)
      player_input

      break if game_over?
    end
    display_game_over_message
  end

  private

  def player_input
    chosen_colors = valid_input_check
    @feedback = [] # reset feedback each attempt

    chosen_colors.each_with_index do |color, index|
      if color == @secret_code[index]
        feedback << RIGHT_POSITION_AND_COLOR
      elsif @secret_code.include?(color)
        feedback << RIGHT_COLOR
      end
    end
    feedback.empty? ? (puts "No matches found") : (puts feedback)
  end

  def valid_input_check
    puts "Please pick 4 pegs from [blue, orange, green, purple, yellow, pink]"
    input = gets.chomp.downcase.split.map(&:to_sym)
    return input if input.all? { |chosen_pegs| COLORED_PEGS.include?(chosen_pegs) } && input.length == 4

    puts "Invalid #{input}"
    valid_input_check
  end

  def game_over?
    feedback == Array.new(4, :white)
  end

  def display_game_over_message
    return puts "Congratulations #{@player_name} you guessed the secret code!" if game_over?

    puts "You lost :("
  end
end

master = Game.new("Odin")
puts master.secret_code.to_s.colorize(:black)
master.play
