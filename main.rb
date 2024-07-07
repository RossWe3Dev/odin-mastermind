require "colorize"

require_relative "lib/game"

def mastermind
  role = choose_role
  game = Game.new(role)
  # puts game.secret_code.to_s.colorize(:black)
  game.play
  play_again?
end

def choose_role
  puts "Would you like to be the (G)uesser or the (C)reator?"
  loop do
    choice = gets.chomp.upcase
    return :guesser if choice == "G"
    return :creator if choice == "C"

    puts "Invalid choice. Please enter 'G' or 'C'."
  end
end

def play_again?
  puts "Press 'y' to play again :) [y/quit]"
  mastermind while gets.chomp.downcase == "y"
  puts "Thanks for playing!"
end

mastermind
