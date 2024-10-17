require "colorize"

class ComputerLogic < GameLogic
  attr_reader :last_guess, :matches_info, :possible_colors, :unused_colors, :guesses_history

  def initialize(name, role)
    super
    @last_guess = nil
    @matches_info = nil
    @possible_colors = COLORED_PEGS.dup
    @unused_colors = COLORED_PEGS.dup
    @guesses_history = []
  end

  protected

  def computer_loop
    12.times do |attempt|
      puts "\nCalculating...".colorize(:light_magenta)
      puts "Attempt number #{attempt + 1}".colorize(:cyan)

      computer_guess
      matches = count_matches
      display_feedback(matches)
      store_guesses_history

      break if game_over?
    end
  end

  def computer_guess # rubocop:disable Metrics/MethodLength
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

      # Clear before next iteration to avoid negative samples
      current_guess.clear
    end
  end

  def store_guesses_history
    @last_guess = @guess
    @matches_info = all_matches
    @guesses_history << @guess
    sleep(0.5)
  end
end
