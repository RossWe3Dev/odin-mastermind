require "colorize"

require_relative "apply_color"

class Game
  include ApplyColor
  COLORED_PEGS = %i[blue purple pink orange yellow green].freeze

  attr_reader :secret_code, :name, :role

  def initialize(role)
    @role = role
    @secret_code = nil
    puts "Hi gamer! What's your name?".colorize(:light_magenta)
    @player_name = gets.chomp.capitalize
    @guess = nil
    @matched_colors = []
  end

  def play
    play_as_guesser if role == :guesser
    play_as_creator if role == :creator
  end

  def play_as_guesser
    generate_random_code
    puts "You have 12 attempts to crack the code, good luck #{@player_name}!".colorize(:light_magenta)

    12.times do |attempt|
      puts "Attempt number #{attempt + 1}".colorize(:cyan)
      player_guess
      matches = count_matches(@guess)
      display_feedback(matches)

      break if game_over?
    end
    player_won?
  end

  def generate_random_code
    @secret_code = Array.new(4) { COLORED_PEGS.sample }
    puts @secret_code.to_s.colorize(:black) # will hide it later
  end

  def player_guess
    loop do
      puts "Pick 4 colors from [#{colorize_pegs(COLORED_PEGS).join(' ')}]"
      @guess = gets.chomp.downcase.split.map(&:to_sym)
      return @guess if @guess.all? { |chosen_pegs| COLORED_PEGS.include?(chosen_pegs) } && @guess.length == 4

      puts "Invalid guess, please only write the color names with blank spaces in between".colorize(:red)
    end
  end

  def play_as_creator
    create_secret_code
    puts "Your code is #{colorize_pegs(@secret_code).join(' ')}, let's see if the computer can crack it!"
    sleep(1)

    computer_guesses = []
    computer_turn = true

    while computer_turn && computer_guesses.length < 12
      puts "Attempt #{computer_guesses.length + 1}".colorize(:cyan)
      computer_guess
      matches = count_matches(@guess)
      display_feedback(matches)

      computer_guesses << @guess # computer guess history
      # Store one color from guess, give basic logic to computer
      @matched_colors = Array.new(matches[:exact_matches]) { @guess[0] }

      computer_turn = !game_over?
      sleep(0.5)
    end
    computer_won?
  end

  def create_secret_code
    loop do
      puts "Create a 4 pegs code with these available colors = [#{colorize_pegs(COLORED_PEGS).join(' ')}]"
      @secret_code = gets.chomp.downcase.split.map(&:to_sym)
      if @secret_code.all? { |chosen_pegs| COLORED_PEGS.include?(chosen_pegs) } && @secret_code.length == 4
        return @secret_code
      end

      puts "Invalid code, please only write the color names with blank spaces in between".colorize(:red)
    end
  end

  def computer_guess
    if @matched_colors && !@matched_colors.empty?
      guess = @matched_colors.dup.shuffle
      # Fill remaining guess slots with random colors
      guess += COLORED_PEGS.sample(4 - guess.length)
    else
      guess = Array.new(4) { COLORED_PEGS.sample }
    end
    @guess = guess
  end

  def count_matches(guess)
    exact_matches = 0
    color_matches = 0

    (0...4).each do |i|
      if guess[i] == @secret_code[i] # Check for exact matches
        exact_matches += 1
        next # Skip to the next peg if it's an exact match
      end

      # Check for non-exact matches (same color but different position)
      index = @secret_code.index(guess[i])
      color_matches += 1 if index && index != i # Not an exact match and color exists in the secret code
    end

    { exact_matches: exact_matches, color_matches: color_matches }
  end

  def display_feedback(matches)
    puts "#{@player_name}'s guess: #{colorize_pegs(@guess).join(' ')}" if role == :guesser
    puts "Computer's guess: #{colorize_pegs(@guess).join(' ')}" if role == :creator
    print "#{matches[:exact_matches]} red pegs (correct color and position),".colorize(:red)
    puts " #{matches[:color_matches]} white pegs (only correct color)"
  end

  def game_over?
    @guess == @secret_code
  end

  def player_won?
    if game_over?
      puts "Congratulations #{@player_name}! You cracked the code!".colorize(:green)
    else
      puts "You ran out of turns and lost :(".colorize(:red)
      puts "The code was: #{colorize_pegs(@secret_code).join(' ')}"
    end
  end

  def computer_won?
    if game_over?
      puts "The computer cracked the code!"
    else
      puts "Congratulations, your code was so hard the computer couldn't crack it!"
    end
  end
end
