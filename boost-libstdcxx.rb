require 'formula'

class BoostLibstdcxx < Formula
  homepage 'http://www.boost.org'
  url 'https://downloads.sourceforge.net/project/boost/boost/1.56.0/boost_1_56_0.tar.bz2'
  sha256 'f94bb008900ed5ba1994a1072140590784b9b5df'

  head 'https://github.com/boostorg/boost.git'

  bottle do
    cellar :any
    sha256 "68c626ad06f13687ff529174ddfef2ecf91d6e22" => :mavericks
    sha256 "cb657544a41c58c7422c16e46b96341e8fe9297d" => :mountain_lion
    sha256 "e23c15575d465efa43ffe7fcfce068e2fe5d4073" => :lion
  end

  env :userpaths

  option :universal
  option 'with-icu', 'Build regexp engine with icu support'
  option 'without-single', 'Disable building single-threading variant'
  option 'without-static', 'Disable building static library variant'
  option 'with-mpi', 'Build with MPI support'
  option :cxx11

  if build.with? 'icu'
    if build.cxx11?
      depends_on 'icu4c' => 'c++11'
    else
      depends_on 'icu4c'
    end
  end

  if build.with? 'mpi'
    if build.cxx11?
      depends_on 'open-mpi' => 'c++11'
    else
      depends_on :mpi => [:cc, :cxx, :optional]
    end
  end

  fails_with :llvm do
    build 2335
    cause "Dropped arguments to functions when linking with boost"
  end

  def install
    # https://svn.boost.org/trac/boost/ticket/8841
    if build.with? 'mpi' and build.with? 'single'
      raise <<-EOS.undent
        Building MPI support for both single and multi-threaded flavors
        is not supported.  Please use '--with-mpi' together with
        '--without-single'.
      EOS
    end

    ENV.universal_binary if build.universal?

    # Force boost to compile with the desired compiler
    open("user-config.jam", "a") do |file|
      file.write "using darwin : : #{ENV.cxx} ;\n"
      file.write "using mpi ;\n" if build.with? 'mpi'
    end

    # libdir should be set by --prefix but isn't
    bootstrap_args = ["--prefix=#{prefix}", "--libdir=#{lib}"]

    if build.with? 'icu'
      icu4c_prefix = Formula['icu4c'].opt_prefix
      bootstrap_args << "--with-icu=#{icu4c_prefix}"
    else
      bootstrap_args << '--without-icu'
    end

    # Handle libraries that will not be built.
    without_libraries = ["python"]

    # The context library is implemented as x86_64 ASM, so it
    # won't build on PPC or 32-bit builds
    # see https://github.com/Homebrew/homebrew/issues/17646
    if Hardware::CPU.ppc? || Hardware::CPU.is_32_bit? || build.universal?
      without_libraries << "context"
      # The coroutine library depends on the context library.
      without_libraries << "coroutine"
    end

    # Boost.Log cannot be built using Apple GCC at the moment. Disabled
    # on such systems.
    without_libraries << "log" if ENV.compiler == :gcc || ENV.compiler == :llvm
    without_libraries << "mpi" if build.without? 'mpi'

    bootstrap_args << "--without-libraries=#{without_libraries.join(',')}"

    # layout should be synchronized with boost-python
    args = ["--prefix=#{prefix}",
            "--libdir=#{lib}",
            "-d2",
            "-j#{ENV.make_jobs}",
            "--layout=tagged",
            "--user-config=user-config.jam",
            "install"]

    if build.with? "single"
      args << "threading=multi,single"
    else
      args << "threading=multi"
    end

    if build.with? "static"
      args << "link=shared,static"
    else
      args << "link=shared"
    end

    args << "address-model=32_64" << "architecture=x86" << "pch=off" if build.universal?

    # Trunk starts using "clang++ -x c" to select C compiler which breaks C++11
    # handling using ENV.cxx11. Using "cxxflags" and "linkflags" still works.
    if build.cxx11?
      args << "cxxflags=-std=c++11"
      if ENV.compiler == :clang
        args << "cxxflags=-stdlib=libstdc++" << "linkflags=-stdlib=libstdc++"
      end
    end



	args << "cxxflags=-stdlib=libstdc++" << "linkflags=-stdlib=libstdc++"



    system "./bootstrap.sh", *bootstrap_args
    system "./b2", *args
  end

  def caveats
    s = ''
    # ENV.compiler doesn't exist in caveats. Check library availability
    # instead.
    if Dir["#{lib}/libboost_log*"].empty?
      s += <<-EOS.undent

      Building of Boost.Log is disabled because it requires newer GCC or Clang.
      EOS
    end

    if Hardware::CPU.ppc? || Hardware::CPU.is_32_bit? || build.universal?
      s += <<-EOS.undent

      Building of Boost.Context and Boost.Coroutine is disabled as they are
      only supported on x86_64.
      EOS
    end

    s
  end
end
