require 'formula'

class Rename <Formula
  url 'http://rename.sourceforge.net/rename-1.3.tar.gz'
  homepage 'http://rename.sourceforge.net/'
  md5 'e6f7dfaef889dc98b7b7bcfdcfeb732d'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
		bin.install "rename"
		man1.install "rename.1"
  end
end