require "colorize"

class Creator < ComputerLogic
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

  def computer_won?
    if game_over?
      puts "\nYou lost, the computer cracked the code!".colorize(:cyan)
    else
      puts "\nCongratulations #{@name}, your code was so hard the computer couldn't crack it!".colorize(:cyan)
    end
  end
end
