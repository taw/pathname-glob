require "pathname"

class Pathname
  def glob(pattern, options=0)
    self_pat = self.to_s.gsub(/([\[\]\{\}\\\*\?])/, "\\\\\\1")
    if pattern.is_a?(Array)
      pattern = pattern.map{|subpattern| File.join(self_pat, subpattern) }
    else
      pattern = File.join(self_pat, pattern)
    end
    Pathname::glob(pattern, options)
  end
end
