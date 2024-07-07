require "colorize"

require_relative "apply_color"

class GameLogic
  include ApplyColor
  COLORED_PEGS = %i[blue purple pink orange yellow green].freeze

  attr_reader :secret_code, :name, :guess, :role

  def initialize(name, role)
    @secret_code = nil
    @name = name
    @guess = nil
    @matches = []
    @role = role
  end

  protected

  def count_matches(guess)
    exact_matches = 0
    color_matches = 0

    (0...4).each do |i|
      if guess[i] == @secret_code[i]
        exact_matches += 1
        next
      end

      index = @secret_code.index(guess[i])
      color_matches += 1 if index && index != i
    end

    { exact_matches: exact_matches, color_matches: color_matches }
  end

  def display_feedback(matches)
    puts "#{@name}'s guess: #{colorize_pegs(@guess).join(' ')}" if role == :guesser
    puts "Computer's guess: #{colorize_pegs(@guess).join(' ')}" if role == :creator
    print "#{matches[:exact_matches]} red pegs (correct color and position),".colorize(:red)
    puts " #{matches[:color_matches]} white pegs (only correct color)"
  end

  def game_over?
    @guess == @secret_code
  end
end
