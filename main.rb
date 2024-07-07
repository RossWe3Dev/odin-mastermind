require "colorize"

require_relative "lib/apply_color"
require_relative "lib/game_logic"
require_relative "lib/guesser"
require_relative "lib/creator"

def mastermind(name)
  role = choose_role
  if role == :guesser
    game = Guesser.new(name, role)
    game.play_as_guesser
  else
    game = Creator.new(name, role)
    game.play_as_creator
  end
  play_again?(name)
end

def choose_role
  puts "Would you like to be the (G)uesser or the (C)reator?".colorize(:cyan)
  loop do
    choice = gets.chomp.upcase
    return :guesser if choice == "G"
    return :creator if choice == "C"

    puts "Invalid choice. Please enter 'G' or 'C'.".colorize(:red)
  end
end

def play_again?(name)
  puts "Press 'y' to play again :) [y/quit]"
  if gets.chomp.downcase == "y"
    mastermind(name)
  else
    puts "Thanks for playing!"
  end
end

puts "Hi gamer! What's your name?"
name = gets.chomp.capitalize

mastermind(name)
