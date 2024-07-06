module Apply_color
  COLOR_MAP = {
    blue: :blue,
    green: :green,
    purple: :magenta,
    pink: :light_magenta,
    orange: :yellow,
    yellow: :light_yellow
  }.freeze

  def colorize_pegs(color_symbols)
    color_symbols.map { |symbol| symbol.to_s.colorize(COLOR_MAP[symbol] || :white) }
  end
end
