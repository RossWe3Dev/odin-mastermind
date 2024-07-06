require "colorize"

require_relative "lib/game"

def mastermind
  puts "Hi gamer! What's your name?"
  name = gets.chomp.capitalize
  game = Game.new(name)
  # puts game.secret_code.to_s.colorize(:black)
  game.play
  puts "Press 'y' to play again :) [y/quit]"
  mastermind while gets.chomp.downcase == "y"
  puts "Thanks for playing!"
end

mastermind
