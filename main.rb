require "colorize"

require_relative "lib/game"

def mastermind
  role = choose_role
  game = Game.new(role)
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
  if gets.chomp.downcase == "y"
    mastermind
  else
    puts "Thanks for playing!"
  end
end

mastermind
