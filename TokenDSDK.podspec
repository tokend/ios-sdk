Pod::Spec.new do |s|
  s.name             = 'TokenDSDK'
  s.version          = '1.0'
  s.summary          = 'TokenD SDK for iOS.'
  s.homepage         = 'https://github.com/tokend/ios-sdk'
  s.author           = { 'Distributed Lab' => 'info@distributedlab.com' }
  s.source           = { :git => 'https://github.com/tokend/ios-sdk.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'
  s.swift_version    = '4.2'
  s.source_files = 'Sources/TokenDSDK/**/*.swift'
  s.exclude_files = 'Example/*'
  s.dependency 'Alamofire', '~> 4.1'
  s.dependency 'TokenDWallet', '< 2.0'
  
  s.subspec 'API' do |ss|
    ss.source_files = 'Sources/TokenDSDK/API/**/*.swift', 'Sources/TokenDSDK/Common/**/*.swift'
  end

  s.subspec 'KeyServer' do |ss|
    ss.source_files = 'Sources/TokenDSDK/KeyServer/**/*.swift', 'Sources/TokenDSDK/Common/**/*.swift'
  end
end
