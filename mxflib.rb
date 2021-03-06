# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Mxflib < Formula
  desc ""
  homepage ""
  url "http://downloads.sourceforge.net/project/mxflib/mxflib/1.0.1/mxflib-1.0.1.tar.gz"
  version "1.0.1"
  sha256 "dcd49c772b3084d2d85b9298248215e9d799d537ed82e02422c8b347b86ef32a"

  # depends_on "cmake" => :build
  depends_on :x11 # if your formula requires any X11/XQuartz components

  def patches
    DATA
  end

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    # Remove unrecognized options if warned by configure
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    # system "cmake", ".", *std_cmake_args
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test mxflib`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end

__END__
diff -rupN mxflib-1.0.1/mxflib/smartptr.h mxflib-1.0.1/mxflib/smartptr.h
--- mxflib-1.0.1/mxflib/smartptr.h  2005-10-13 14:36:11.000000000 +0100
+++ mxflib-1.0.1/mxflib/smartptr.h  2015-08-05 04:19:24.000000000 +0100
@@ -503,7 +503,7 @@ namespace mxflib
 		}
 
 		//! Comparison function to allow sorting by indexed value
-		bool operator<(SmartPtr &Other) { return this.operator<(*Other->GetPtr()); }
+		bool operator<(SmartPtr &Other) { return this->operator<(*Other->GetPtr()); }
 
 		//! Get a cast version of the pointer
 		/*! This is used via the SmartPtr_Cast() Macro to allow MSVC 6 to work!!
