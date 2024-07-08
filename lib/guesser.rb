require "colorize"

class Guesser < GameLogic
  def play_as_guesser
    generate_random_code
    puts "You have 12 attempts to crack the code, good luck #{@name}!".colorize(:light_magenta)

    12.times do |attempt|
      puts "Attempt number #{attempt + 1}".colorize(:cyan)
      player_guess
      matches = count_matches
      display_feedback(matches)

      break if game_over?
    end
    player_won?
  end

  private

  def generate_random_code
    @secret_code = Array.new(4) { COLORED_PEGS.sample }
    # puts @secret_code.to_s.colorize(:black) # toggle comment to test
  end

  def player_guess
    loop do
      puts "Pick 4 colors from [#{colorize_pegs(COLORED_PEGS).join(' ')}]"

      @guess = gets.chomp.downcase.split.map(&:to_sym)
      return if @guess.all? { |chosen_pegs| COLORED_PEGS.include?(chosen_pegs) } && @guess.length == 4

      puts "Invalid guess, please only write the color names with blank spaces in between".colorize(:red)
    end
  end

  def player_won?
    if game_over?
      puts "Congratulations #{@name}! You cracked the code!".colorize(:green)
    else
      puts "You ran out of turns and lost :(".colorize(:red)
      puts "The code was: #{colorize_pegs(@secret_code).join(' ')}"
    end
  end
end
