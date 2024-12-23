Pod::Spec.new do |spec|
  spec.name         = 'BoringSSL-GRPC'
  spec.version      = '0.0.36'
  spec.summary      = 'BoringSSL for gRPC'
  spec.description  = <<-DESC
    BoringSSL is a fork of OpenSSL that is designed to meet Google’s needs.
  DESC
  spec.homepage     = 'https://github.com/google/boringssl'
  spec.license      = { :type => 'Apache 2.0' }
  spec.authors      = { 'Google' => 'opensource@google.com' }
  spec.source       = { :path => '.' }
  spec.source_files = 'include/**/*.{h,c,cc,cpp}', 'ssl/**/*.{h,c,cc,cpp}', 'crypto/**/*.{h,c,cc,cpp}'
  spec.requires_arc = false
end

