require "colorize"

class Creator < GameLogic
  attr_accessor :last_guess, :matches_info, :possible_colors, :unused_colors

  def initialize(name, role)
    super
    @last_guess = nil
    @matches_info = nil
    @possible_colors = COLORED_PEGS.dup
    @unused_colors = COLORED_PEGS.dup
  end

  def play_as_creator
    create_secret_code
    puts "Your code is #{colorize_pegs(@secret_code).join(' ')}, let's see if the computer can crack it!"
    sleep(1)

    computer_loop
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

  def computer_loop
    12.times do |attempt|
      puts "Attempt number #{attempt + 1}".colorize(:cyan)
      computer_guess
      matches = count_matches
      display_feedback(matches)

      # Store last guess symbols and matches info
      @last_guess = @guess
      # @matches_info = matches
      @matches_info = all_matches

      sleep(0.3)
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
    current_guess += @last_guess.sample(@matches_info)
    # Prioritize unused colors
    current_guess += @unused_colors.sample(4 - current_guess.length) unless @unused_colors.empty?
    # Fallback to possible colors
    current_guess += @possible_colors.sample(4 - current_guess.length)

    current_guess
  end

  def computer_won?
    if game_over?
      puts "You lost, the computer cracked the code!".colorize(:cyan)
    else
      puts "Congratulations #{@name}, your code was so hard the computer couldn't crack it!".colorize(:cyan)
    end
  end
end
