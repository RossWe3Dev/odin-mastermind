require "colorize"

class Game
  COLORED_PEGS = %i[blue orange green purple yellow pink].freeze

  attr_reader :secret_code, :name

  def initialize(name)
    @secret_code = Array.new(4) { COLORED_PEGS.sample }
    @player_name = name
    @guess = nil
  end

  def play
    12.times do |attempt|
      puts "Attempt number #{attempt + 1}".colorize(:magenta)
      player_guess
      display_feedback

      break if game_over?
    end
    won?
  end

  private

  def player_guess
    loop do
      puts "Please pick 4 colors from [blue, orange, green, purple, yellow, pink]".colorize(:green)
      @guess = gets.chomp.downcase.split.map(&:to_sym)
      return @guess if @guess.all? { |chosen_pegs| COLORED_PEGS.include?(chosen_pegs) } && @guess.length == 4

      puts "Invalid guess".colorize(:red)
    end
  end

  def display_feedback
    white_pegs = (0...4).count { |i| @guess[i] == @secret_code[i] }

    red_pegs = [(matches_count - white_pegs), 0].max

    print "#{white_pegs} white pegs (correct color and position),".colorize(:white)
    puts " #{red_pegs} red pegs (only correct color)".colorize(:red)
    @guess
  end

  def matches_count
    all_matches = 0
    @secret_code.each do |secret_peg|
      all_matches += 1 if @guess.any? { |guess_peg| guess_peg == secret_peg }
    end
    all_matches
  end

  def game_over?
    @guess == @secret_code
  end

  def won?
    if game_over?
      puts "Congratulations! You cracked the code!".colorize(:green)
    else
      puts "You ran out of turns and lost :(".colorize(:red)
      puts "The code was: #{@secret_code.join(', ')}"
    end
  end
end

master = Game.new("Odin")
puts master.secret_code.to_s.colorize(:black)
master.play