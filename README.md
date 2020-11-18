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

## API Models Generating

To generate API models you should have prepared `.yaml` files with these API models. Place them at **../Regources/v2/yaml/your\_svc\_specs** relatively to this SDK root folder. Also place **schema** folder from **Resources** to **Regources/v2/yaml**

Resulting folders structure should look like this:

```
| Regources
   | v2
      | yaml
         | cards_specs
            | inner
            | resources
         | schema
| iOS-SDK 
```

This setup you should perform only before first start, after you will only need to add\update `.yaml` files in `_specs` folders.

Generation instruction:

1. Go to **Scripts** folder;
2. Run `ruby generate_api_data.rb -n <namespace_name> -f <specs_folder_name>`;
3. Repeat step 2 for every specs folder you have.

> where:
> 
>  - `<namespace_name>` is the name for namespace `enum` that will be created for all generated API models.
> 
>  - `<specs_folder_name>` is the name of `_specs` folder with your `.yaml` files.  

## Documentation
Visit our [Knowledge base](https://tokend.gitbook.io/knowledge-base/) and [API documentation](https://tokend.gitlab.io/docs) to get information on working with TokenD.

Also take a look at [Wiki](https://github.com/tokend/ios-sdk/wiki) to learn how to use SDK in your projects.

## Credits
<a href="https://distributedlab.com/" target="_blank">Distributed Lab</a>, 2019