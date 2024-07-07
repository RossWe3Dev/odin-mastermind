require "colorize"

class Creator < GameLogic
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

      computer_guesses << @guess # Add guess to history (optional)
      # Store one color from guess, give basic logic to computer
      @matched_colors = Array.new(matches[:exact_matches]) { @guess[0] }

      computer_turn = !game_over?
      sleep(0.5)
    end
    computer_won?
  end

  private

  def create_secret_code
    loop do
      puts "This are the available colors = [#{colorize_pegs(COLORED_PEGS).join(' ')}]"
      puts "Now #{@name}, create a code with 4 color names (can contain duplicates)."
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

  def computer_won?
    if game_over?
      puts "The computer cracked the code!"
    else
      puts "Congratulations #{@name}, your code was so hard the computer couldn't crack it!"
    end
  end
end
