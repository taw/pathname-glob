describe "Pathname#glob" do
  let(:files) {[
    "foo/1.txt",
    "foo/2.txt",
    "foo/3.html",
    "bar/4.html",
    "bar/abc/5.html",
    "bar/6.gif",
    "lol/[]{}/?*?*?*?!\\\\?\\/lol/1.txt",
    "lol/[]{}/?*?*?*?!\\\\?\\/lol/2.gif",
    "lol/[]{}/?*?*?*?!\\\\?\\/lol/3.txt",
  ]}
  let(:tmpdir) {
    Pathname(@dir)
  }
  let(:result) {
    (tmpdir+base_path).glob(*args).map{|path| path.relative_path_from(tmpdir)}
  }

  before(:each) do
    @dir = Dir.mktmpdir
    files.each do |path|
      (tmpdir+path).parent.mkpath
      FileUtils.touch (tmpdir+path)
    end
  end

  after(:each) do
    FileUtils.remove_entry(@dir)
  end

  describe do
    let(:base_path) { "foo" }
    let(:args) { ["*.txt"] }
    it do
      expect(result).to match_array([
        Pathname("foo/1.txt"),
        Pathname("foo/2.txt"),
      ])
    end
  end

  describe do
    let(:base_path) { "bar" }
    let(:args) { ["*.html"] }
    it do
      expect(result).to eq([
        Pathname("bar/4.html"),
      ])
    end
  end

  describe do
    let(:base_path) { "bar" }
    let(:args) { ["**/*.html"] }
    it do
      expect(result).to match_array([
        Pathname("bar/4.html"),
        Pathname("bar/abc/5.html"),
      ])
    end
  end

  describe "array of arguments" do
    let(:base_path) { "foo" }
    let(:args) { [["?.html", "?.txt"]] }
    it do
      expect(result).to match_array([
        Pathname("foo/3.html"),
        Pathname("foo/1.txt"),
        Pathname("foo/2.txt"),
      ])
    end
  end

  describe "options" do
    let(:base_path) { "foo" }
    let(:args) { ["*", 0] }
    it do
      expect(result).to match_array([
        Pathname("foo/1.txt"),
        Pathname("foo/2.txt"),
        Pathname("foo/3.html"),
      ])
    end
  end

  describe "options" do
    let(:base_path) { "foo" }
    let(:args) { ["*", File::FNM_DOTMATCH] }
    it do
      expect(result).to match_array([
        Pathname("foo"), # .
        Pathname("."), # ..
        Pathname("foo/1.txt"),
        Pathname("foo/2.txt"),
        Pathname("foo/3.html"),
      ])
    end
  end

  # Special characters as per dir.c in ruby sources:
  # hard special (unescapable): / \0
  # unix: { } \ [ ] * ?
  # There's also something about Win32 and . and ~ that I don't really get
  describe "escaping" do
    let(:base_path) { "lol/[]{}/?*?*?*?!\\\\?\\/lol" }
    let(:args) { ["*.txt"] }
    it do
      expect(result).to match_array([
        Pathname("lol/[]{}/?*?*?*?!\\\\?\\/lol/1.txt"),
        Pathname("lol/[]{}/?*?*?*?!\\\\?\\/lol/3.txt",),
      ])
    end
  end

  describe "block" do
    let(:base_path) { "foo" }
    let(:args) { ["*.txt"] }
    it do
      yields = []
      result = (tmpdir+base_path).glob(*args){|*x|
        yields << x
      }
      expect(result).to eq(nil)
      expect(yields).to match_array([
        [tmpdir + "foo/1.txt"],
        [tmpdir + "foo/2.txt"],
      ])
    end
  end
end
