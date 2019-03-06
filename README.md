# TokenD iOS SDK

This library facilitates interaction with TokenD-based system from iOS app.

## Installation

TokenDSDK is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
...
source 'git@github.com:tokend/ios-specs.git'
...
pod 'TokenDSDK'
...
```

TokenDSDK uses its own pod spec repository. In order to setup it perform once in Terminal:

```ruby
pod repo add ios-specs 'git@github.com:tokend/ios-specs.git'
```

## Usage
```swift
import TokenDSDK

let userAgent: String = ...

let apiConfiguration = ApiConfiguration(
    urlString: "https://api.testnet.tokend.org",
    userAgent: ...
)

let callbacks = ApiCallbacks(onTFARequired: { (tfaInput, cancel) in 
    // handle TFA...
})

let keyDataProvider: RequestSignKeyDataProviderProtocol = ...

// TokenD Apis collection
let tokenDApi = TokenDSDK.API(
    configuration: apiConfiguration,
    callbacks: callbacks,
    keyDataProvider: keyDataProvider
)


let requestSigner: RequestSignerProtocol = ...

let verifyApi = TFAVerifyApi(
    apiConfiguration: apiConfiguration,
    requestSigner: requestSigner
)

// Key Server Api
let keyServerApi = KeyServerApi(
    apiConfiguration: apiConfiguration,
    callbacks: callbacks,
    verifyApi: verifyApi,
    requestSigner: requestSigner
)
```

## Documentation
Visit our [Knowledge base](https://tokend.gitbook.io/knowledge-base/) and [API documentation](https://tokend.gitlab.io/docs) to get information on working with TokenD.

Also take a look at [Wiki](https://github.com/tokend/ios-sdk/wiki) to learn how to use SDK in your projects.

## Credits
<a href="https://distributedlab.com/" target="_blank">Distributed Lab</a>, 2019