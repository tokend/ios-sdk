Pod::Spec.new do |s|
  s.name             = 'TokenDSDK'
  s.version          = '3.3.2'
  s.summary          = 'TokenD SDK for iOS.'
  s.homepage         = 'https://github.com/tokend/ios-sdk'
  s.license          = { type: 'Apache License, Version 2.0', file: 'LICENSE' }
  s.author           = { 'Distributed Lab' => 'dev@distributedlab.com' }
  s.source           = { git: 'https://github.com/tokend/ios-sdk.git', tag: s.version.to_s }
  s.swift_version    = '4.2'
  s.exclude_files    = 'Example/*'

  s.ios.deployment_target = '10.0'

  s.ios.dependency 'TokenDWallet', '3.1.1'

  v1_source_files = 'Sources/Common/**/*.swift',
                    'Sources/v1/API/**/*.swift',
                    'Sources/v1/Common/**/*.swift'

  v1_alamofire_files = 'Sources/Alamofire/Common/**/*.swift',
                       'Sources/Alamofire/v1/**/*.swift'

  jsonapi_v3_source_files = 'Sources/Common/**/*.swift',
                            'Sources/JSONAPI/Common/**/*.swift',
                            'Sources/JSONAPI/v3/**/*.swift'

  jsonapi_muna_v3_source_files = 'Sources/MUNA/v3/**/*.swift'

  jsonapi_contopass_v3_source_files = 'Sources/Contopass/v3/**/*.swift'

  jsonapi_contofa_v3_source_files = 'Sources/ContoFA/v3/**/*.swift'
  
  jsonapi_dms_v3_source_files = 'Sources/DMS/v3/**/*.swift'

  jsonapi_v3_alamofire_files = 'Sources/Alamofire/Common/**/*.swift',
                               'Sources/Alamofire/JSONAPI/**/*.swift'

  rx_jsonapi_v3_source_files = 'Sources/RxSwift/JSONAPI/Common/**/*.swift',
                               'Sources/RxSwift/JSONAPI/v3/**/*.swift'

  key_server_v1_source_files = 'Sources/Common/**/*.swift',
                               'Sources/KeyServer/**/*.swift'

  s.subspec 'API' do |ss|
    ss.source_files = v1_source_files
  end

  s.subspec 'AlamofireNetwork' do |ss|
    ss.source_files = v1_alamofire_files
    ss.dependency 'Alamofire', '5.3.0'
  end

  s.subspec 'JSONAPI' do |ss|
    ss.source_files = jsonapi_v3_source_files
    ss.dependency 'DLJSONAPI', '>= 1.0.9'
    ss.xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => '$(inherited)' }
  end

  s.subspec 'MUNA' do |ss|
    ss.xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'TOKENDSDK_MUNAAPI' }
    ss.source_files = jsonapi_muna_v3_source_files
    ss.dependency 'TokenDSDK/JSONAPI'
  end

  s.subspec 'Contopass' do |ss|
    ss.xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'TOKENDSDK_CONTOPASSAPI' }
    ss.source_files = jsonapi_contopass_v3_source_files
    ss.dependency 'TokenDSDK/JSONAPI'
  end

  s.subspec 'ContoFA' do |ss|
    ss.xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'TOKENDSDK_CONTOFAAPI' }
    ss.source_files = jsonapi_contofa_v3_source_files
    ss.dependency 'TokenDSDK/JSONAPI'
  end
  
  s.subspec 'DMS' do |ss|
    ss.xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'TOKENDSDK_DMSAPI' }
    ss.source_files = jsonapi_dms_v3_source_files
    ss.dependency 'TokenDSDK/JSONAPI'
  end

  s.subspec 'AlamofireNetworkJSONAPI' do |ss|
    ss.source_files = jsonapi_v3_alamofire_files
    ss.dependency 'Alamofire', '5.3.0'
  end

  s.subspec 'RxJSONAPI' do |ss|
    ss.source_files = rx_jsonapi_v3_source_files
    ss.dependency 'RxSwift', '~> 6.0.0-rc.1'
    ss.dependency 'RxCocoa', '~> 6.0.0-rc.1'
  end

  s.subspec 'KeyServer' do |ss|
    ss.source_files = key_server_v1_source_files
  end

  s.default_subspecs = 'API', 'JSONAPI', 'KeyServer'
end
