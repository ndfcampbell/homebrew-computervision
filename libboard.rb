require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Libboard < Formula
  homepage 'http://libboard.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/libboard/libboard/0.9.0/libboard-0.9.0.tar.gz'
  version 'pl11'
  sha1 '13fad93eec3c1883c93214c4c0aa010a7740ebab'

  # depends_on 'cmake' => :build
  #depends_on :x11 # if your formula requires any X11/XQuartz components

  def install
    # ENV.j1  # if your formula's build system can't parallelize
	
    system "./configure", "--prefix=#{prefix}"

    system "make", "install"

  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test clippoly`.
    system "false"
  end
end

