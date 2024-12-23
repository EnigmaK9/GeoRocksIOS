Pod::Spec.new do |spec|
  spec.name         = 'BoringSSL-GRPC'
  spec.version      = '0.0.36'
  spec.summary      = 'BoringSSL for gRPC'
  spec.homepage     = 'https://github.com/google/boringssl'
  spec.license      = { :type => 'Apache 2.0' }
  spec.authors      = { 'Google' => 'opensource@google.com' }
  spec.source       = { :path => '.' }
  spec.source_files = '**/*.{h,c,cc,cpp}'
  spec.requires_arc = true
end

