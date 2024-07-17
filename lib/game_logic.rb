require "colorize"

require_relative "apply_color"

class GameLogic
  include ApplyColor
  COLORED_PEGS = %i[blue purple pink orange yellow green].freeze

  attr_accessor :guess
  attr_reader :secret_code, :name, :role

  def initialize(name, role)
    @secret_code = nil
    @name = name
    @guess = nil
    @role = role
  end

  protected

  def count_matches
    exact_matches = (0...4).count { |i| @guess[i] == @secret_code[i] }
    color_matches = [(all_matches - exact_matches), 0].max

    { exact_matches: exact_matches, color_matches: color_matches }
  end

  def all_matches
    all_matches = 0
    guess_copy = @guess.dup

    @secret_code.each do |secret_peg|
      # Find the index of matching peg, if none (nil) skip to the next iteration
      index = guess_copy.index(secret_peg)
      next unless index

      all_matches += 1
      # Remove the matched peg from the guess copy to avoid overcounting
      guess_copy.delete_at(index)
    end
    all_matches
  end

  def display_feedback(matches)
    puts "\n#{@name}'s guess: #{colorize_pegs(@guess).join(' ')}" if role == :guesser
    puts "Computer's guess: #{colorize_pegs(@guess).join(' ')}" if role == :creator
    print "#{matches[:exact_matches]} red pegs (correct color and position),".colorize(:red)
    puts " #{matches[:color_matches]} white pegs (only correct color)"
  end

  def game_over?
    @guess == @secret_code
  end
end
