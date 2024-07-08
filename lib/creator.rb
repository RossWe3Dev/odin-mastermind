require "colorize"

class Creator < GameLogic
  attr_accessor :current_guess, :matches_info

  def initialize(name, role)
    super
    @current_guess = []
    @matches_info = nil
  end

  def play_as_creator
    create_secret_code
    puts "Your code is #{colorize_pegs(@secret_code).join(' ')}, let's see if the computer can crack it!"
    sleep(1)

    12.times do |attempt|
      puts "Attempt number #{attempt + 1}".colorize(:cyan)
      computer_guess
      matches = count_matches
      display_feedback(matches)

      # Store current guess symbols and all matches
      @current_guess = @guess
      @matches_info = all_matches

      sleep(0.5)
      break if game_over?
    end

    # computer_guesses = []  # might keep this approach if I want to use guesses history
    # computer_turn = true
    # while computer_turn && computer_guesses.length < 12
    #   puts "Attempt #{computer_guesses.length + 1}".colorize(:cyan)
    #   computer_guess
    #   matches = count_matches
    #   display_feedback(matches)

    #   computer_guesses << @guess # Add guess to history (optional)
    #   # Store current guess symbols and all matches
    #   @current_guess = @guess
    #   @matches_info = all_matches

    #   computer_turn = !game_over?
    #   sleep(0.5)
    # end

    computer_won?
  end

  private

  def create_secret_code
    loop do
      puts "This are the available colors = [#{colorize_pegs(COLORED_PEGS).join(' ')}]"
      puts "Now #{@name}, create a code with 4 color names (can contain duplicates).".colorize(:cyan)

      @secret_code = gets.chomp.downcase.split.map(&:to_sym)
      if @secret_code.all? { |chosen_pegs| COLORED_PEGS.include?(chosen_pegs) } && @secret_code.length == 4
        return @secret_code
      end

      puts "Invalid code, please only write the color names with blank spaces in between".colorize(:red)
    end
  end

  def computer_guess
    guess = []
    if @current_guess.empty? # First iteration
      guess = Array.new(4) { COLORED_PEGS.sample }
    else
      guess += @current_guess.sample(@matches_info)
      # Fill remaining guess slots with random colors
      guess += COLORED_PEGS.sample(4 - guess.length)
    end
    @guess = guess
  end

  def computer_won?
    if game_over?
      puts "You lost, the computer cracked the code!".colorize(:cyan)
    else
      puts "Congratulations #{@name}, your code was so hard the computer couldn't crack it!".colorize(:cyan)
    end
  end
end
