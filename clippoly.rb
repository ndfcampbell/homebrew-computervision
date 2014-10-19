require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Clippoly < Formula
  homepage 'http://clippoly.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/clippoly/clippoly/clippoly-pl11/clippoly-pl11.tar.gz'
  version 'pl11'
  sha1 '421df5594bcac83792377d322892d903743faa26'

  def patches
    DATA
  end

  # depends_on 'cmake' => :build
  #depends_on :x11 # if your formula requires any X11/XQuartz components

  def install
    # ENV.j1  # if your formula's build system can't parallelize

    system "make lib" # if this fails, try separate make/make install steps

    lib.install 'libPolyClip.a'

	def includeSubdir
	  include/'libPolyClip'
	end

	includeSubdir.install Dir['*.h']

  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test clippoly`.
    system "false"
  end
end

__END__
diff -rupN clippoly-pl11/Makefile clippoly-pl11/Makefile
--- clippoly-pl11/Makefile	2005-02-28 21:12:04.000000000 +0000
+++ clippoly-pl11/Makefile	2012-09-07 03:40:41.000000000 +0100
@@ -1,5 +1,6 @@
 #CCC	= g++ -B/usr/local/lib/gcc-lib/sparc-sun-solaris2.3/rotd/
-CCC	= g++ -fno-implicit-templates
+##CCC	= g++ -fno-implicit-templates
+CCC = g++
 #CCC	= CC
 # You can use gcc as a C compiler if cc doesn't work
 CC	= gcc 
@@ -30,6 +31,11 @@ test:	prog
 	prog < in_file > out_file
 	diff -b out_file.dist out_file
 
+lib:	nclip.o primitives.o posadder.o poly.o poly_io.o templates.o err.o graphadd.o graphmat.o graphmat++.o
+	@echo Creating Library..
+	ar rc libPolyClip.a nclip.o primitives.o posadder.o poly.o poly_io.o templates.o err.o graphadd.o graphmat.o graphmat++.o
+	
+
 clean:
 	rm -f *.o prog core out_file
 
diff -rupN clippoly-pl11/graphmat.h clippoly-pl11/graphmat.h
--- clippoly-pl11/graphmat.h	2005-02-28 21:12:05.000000000 +0000
+++ clippoly-pl11/graphmat.h	2012-09-07 03:54:13.000000000 +0100
@@ -68,7 +68,7 @@
 #include <stdio.h>
 #endif
 #ifndef __malloc_h
-#include <malloc.h>
+#include <sys/malloc.h>
 #endif
 #ifndef __math_h
 #include <math.h>
diff -rupN clippoly-pl11/nclip.cc clippoly-pl11/nclip.cc
--- clippoly-pl11/nclip.cc	2005-02-28 17:21:12.000000000 +0000
+++ clippoly-pl11/nclip.cc	2012-09-07 03:49:33.000000000 +0100
@@ -47,7 +47,7 @@ static const char rcs_id[] = "$Header: /
 #include	<graphadd.h>
 #include        <err.h>
 
-#include	<malloc.h>
+#include	<sys/malloc.h>
 
 #include	<poly.h>
 #include	<primitives.h>
diff -rupN clippoly-pl11/poly.h clippoly-pl11/poly.h
--- clippoly-pl11/poly.h	2005-02-28 21:12:05.000000000 +0000
+++ clippoly-pl11/poly.h	2012-09-07 03:53:49.000000000 +0100
@@ -66,6 +66,8 @@ enum EdgeState { Unknown, None, Shared, 
 // enum LogicStates;
 class Vec;
 
+class Poly;
+
 class PolyNode
 {
 	friend class Poly;
