require 'formula'

class Vxl < Formula
  homepage 'http://vxl.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/vxl/vxl/1.17/vxl-1.17.0.tar.gz'
  sha1 '223fab80d734bf20e96aa5c29173fca371e0ae28'

  bottle do
  #  sha1 "01d337030d2848fb4b6fe6bd35f886c43693b5bf" => :yosemite
  #  sha1 "1821091bafdcf45b25bbb1d4075fc31e1e7cf6a3" => :mavericks
  #  sha1 "f070e9f3d03d2287daa4af0440f24e4f0e7e2fcf" => :mountain_lion
  end

  depends_on 'cmake' => :build

  def install
    ENV.cxx11 if build.cxx11?
    args = ["-DCMAKE_INSTALL_PREFIX=#{prefix}",
            "-DCMAKE_BUILD_TYPE=RelWithDebInfo",
            "-DCMAKE_BACKWARDS_COMPATIBILITY=2.6",
            "-DBUILD_BRL=OFF",
            "-DBUILD_CONTRIB=OFF",
            "-DBUILD_CONVERSIONS=OFF",
            "-DBUILD_CORE_GEOMETRY=OFF",
            "-DBUILD_CORE_IMAGING=OFF",
            "-DBUILD_CORE_UTILITIES=OFF",
            "-DBUILD_CORE_VIDEO=OFF",
            "-DBUILD_EXAMPLES=OFF",
            "-DBUILD_GEL=OFF",
            "-DBUILD_MUL=OFF",
            "-DBUILD_MUL_TOOLS=OFF",
            "-DBUILD_OUL=OFF",
            "-DBUILD_OXL=OFF",
            "-DBUILD_PRIP=OFF",
            "-DBUILD_RPL=OFF",
            "-DBUILD_TBL=OFF",
            "-DBUILD_TESTING=OFF",
            "-DCMAKE_CXX_COMPILER=/usr/bin/g++",
            "-DCMAKE_CXX_FLAGS=\"-arch x86_64 -Xarch_x86_64 -mmacosx-version-min=10.7\"",
            "-DCMAKE_C_COMPILER=/usr/bin/gcc",
            "-DCMAKE_C_FLAGS=\"-arch x86_64 -Xarch_x86_64 -mmacosx-version-min=10.7\"",
            "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON",
            "-DCMAKE_INSTALL_NAME_DIR=#{HOMEBREW_PREFIX}/lib"]
	
	#args << "cxxflags=-stdlib=libstdc++" << "linkflags=-stdlib=libstdc++"
	#args << "-DCMAKE_CXX_FLAGS=-stdlib=libstdc++"

    args << '.'

    system "cmake", *args
    system "make VERBOSE=1 vnl"
    system "make -j 8 vnl vnl_algo vnl_io vnl_xio install"
  end
end

