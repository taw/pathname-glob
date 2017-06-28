require "pathname"

class Pathname
  def glob(pattern)
    Pathname::glob((self + pattern).to_s)
  end
end
