describe "Pathname#glob" do
  let(:files) {[
    "foo/1.txt",
    "foo/2.txt",
    "foo/3.html",
    "bar/4.html",
    "bar/abc/5.html",
    "bar/6.gif",
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
      expect(result).to eq([
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

  describe "basic exaples" do
    let(:base_path) { "bar" }
    let(:args) { ["**/*.html"] }
    it do
      expect(result).to eq([
        Pathname("bar/4.html"),
        Pathname("bar/abc/5.html"),
      ])
    end
  end
end
