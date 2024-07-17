require "colorize"

class Creator < GameLogic
  attr_accessor :last_guess, :matches_info, :possible_colors, :unused_colors, :guesses_history

  def initialize(name, role)
    super
    @last_guess = nil
    @matches_info = nil
    @possible_colors = COLORED_PEGS.dup
    @unused_colors = COLORED_PEGS.dup
    @guesses_history = []
  end

  def play_as_creator
    create_secret_code
    puts "\nYour code is #{colorize_pegs(@secret_code).join(' ')}, let's see if the computer can crack it!"
    sleep(1)

    computer_loop
    computer_won?
  end

  private

  def create_secret_code
    loop do
      puts "\nThis are the available colors = [#{colorize_pegs(COLORED_PEGS).join(' ')}]"
      puts "Now #{@name}, create a code with 4 color names (can contain duplicates).".colorize(:cyan)

      @secret_code = gets.chomp.downcase.split.map(&:to_sym)
      if @secret_code.all? { |chosen_pegs| COLORED_PEGS.include?(chosen_pegs) } && @secret_code.length == 4
        return @secret_code
      end

      puts "Invalid code, please only write the color names with blank spaces in between".colorize(:red)
    end
  end

  def computer_loop
    20.times do |attempt|
      puts "\nCalculating...".colorize(:light_magenta)
      puts "Attempt number #{attempt + 1}".colorize(:cyan)

      computer_guess
      matches = count_matches
      display_feedback(matches)
      store_guesses_history

      break if game_over?
    end
  end

  def computer_guess
    current_guess = []
    if !@last_guess # First iteration
      current_guess = Array.new(4) { @possible_colors.sample }
    elsif @last_guess && @matches_info.zero?
      @possible_colors -= @last_guess
      current_guess = Array.new(4) { @possible_colors.sample }
    else
      current_guess = computer_logic(current_guess)
    end
    # Update unused_colors
    @unused_colors -= current_guess

    @guess = current_guess
  end

  def computer_logic(current_guess)
    loop do
      current_guess += @last_guess.sample(@matches_info)
      # Prioritize unused colors
      current_guess += @unused_colors.sample(4 - current_guess.length) unless @unused_colors.empty?
      # Fallback to possible colors
      current_guess += @possible_colors.sample(4 - current_guess.length)
      return current_guess unless @guesses_history.include?(current_guess)

      # Clear before next itaration to avoid negative samples
      current_guess.clear
    end
  end

  def store_guesses_history
    @last_guess = @guess
    @matches_info = all_matches
    @guesses_history << @guess
    sleep(0.5)
  end

  def computer_won?
    if game_over?
      puts "\nYou lost, the computer cracked the code!".colorize(:cyan)
    else
      puts "\nCongratulations #{@name}, your code was so hard the computer couldn't crack it!".colorize(:cyan)
    end
  end
end
