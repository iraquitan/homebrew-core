class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Apple Swift."
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/3.0.6.tar.gz"
  sha256 "279c24886f5a88f332db2e0f745de55b6267e697ce4ba42f7d91566b6cf11be3"
  revision 1

  bottle do
    cellar :any
    sha256 "e1262222c7ce583b7bbf527fee3b4e3d582647eb55287cc9c9db0d97498a1ffe" => :sierra
    sha256 "a4a72ad4a670b29b484daac3bf0e82170e1e17f061be629810f5d29c930c7355" => :el_capitan
    sha256 "c55c0dcd695c862d1aea108889cf0d1c28fe4b9be86e4b675e4d2ce577ea7f11" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "protobuf"

  def install
    # Regenerate the generated files for protobuf 3.2.0
    # See https://github.com/alexeyxo/protobuf-swift/issues/200
    system "protoc", "-Iplugin/compiler",
                     "plugin/compiler/google/protobuf/descriptor.proto",
                     "plugin/compiler/google/protobuf/swift-descriptor.proto",
                     "--cpp_out=plugin/compiler"
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    testdata = <<-EOS.undent
      syntax = "proto3";
      enum Flavor {
        CHOCOLATE = 0;
        VANILLA = 1;
      }
      message IceCreamCone {
        int32 scoops = 1;
        Flavor flavor = 2;
      }
    EOS
    (testpath/"test.proto").write(testdata)
    system "protoc", "test.proto", "--swift_out=."
  end
end
