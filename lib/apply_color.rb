module ApplyColor
  COLOR_MAP = {
    blue: :blue,
    green: :light_green,
    purple: :magenta,
    pink: :light_red,
    orange: :yellow,
    yellow: :light_yellow
  }.freeze

  def colorize_pegs(color_symbols_array)
    color_symbols_array.map { |symbol| symbol.to_s.colorize(COLOR_MAP[symbol] || :default) }
  end
end
