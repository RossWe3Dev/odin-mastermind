require "colorize"

require_relative "apply_color"

class Game
  include Apply_color
  COLORED_PEGS = %i[blue purple pink orange yellow green].freeze

  attr_reader :secret_code, :name

  def initialize(name)
    @secret_code = Array.new(4) { COLORED_PEGS.sample }
    @player_name = name
    @guess = nil
  end

  def play
    puts "Hello #{@player_name}, you have 12 attempts to crack the code, good luck :)".colorize(:light_magenta)
    12.times do |attempt|
      puts "Attempt number #{attempt + 1}".colorize(:cyan)
      player_guess
      display_feedback

      break if game_over?
    end
    won?
  end

  private

  def player_guess
    loop do
      puts "Please pick 4 colors from [#{colorize_pegs(COLORED_PEGS).join(' ')}]"
      @guess = gets.chomp.downcase.split.map(&:to_sym)
      return @guess if @guess.all? { |chosen_pegs| COLORED_PEGS.include?(chosen_pegs) } && @guess.length == 4

      puts "Invalid guess".colorize(:red)
    end
  end

  def display_feedback
    exact_matches = (0...4).count { |i| @guess[i] == @secret_code[i] }
    color_matches = [(matches_count - exact_matches), 0].max

    puts "Your guess: #{colorize_pegs(@guess).join(' ')}"
    print "#{exact_matches} red pegs (correct color and position),".colorize(:red)
    puts " #{color_matches} white pegs (only correct color)"
    @guess
  end

  def matches_count
    all_matches = 0
    guess_copy = @guess.dup

    @secret_code.each do |secret_peg|
      # Find the index of matching peg, if none (nil) skip to the next iteration
      index = guess_copy.index(secret_peg)
      next unless index

      all_matches += 1
      # Remove the matched peg from the guess copy to avoid overcounting
      guess_copy.delete_at(index)
    end
    all_matches
  end

  def game_over?
    @guess == @secret_code
  end

  def won?
    if game_over?
      puts "Congratulations #{@player_name}! You cracked the code!".colorize(:green)
    else
      puts "You ran out of turns and lost :(".colorize(:red)
      puts "The code was: #{colorize_pegs(@secret_code).join(' ')}"
    end
  end
end
