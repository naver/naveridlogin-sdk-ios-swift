# Naver ID Login SDK for iOS Swift

[한국어](README.md) | English

Naver ID Login SDK and sample project for iOS.

Third-party apps can use this SDK to add Naver login, logout, and token management with minimal setup.



See the [Naver Developers tutorial](https://developers.naver.com/docs/login/ios/ios.md) for details. The guide is written in Korean.

## Requirements

- iOS 15.0 or later
- Xcode 16.0 or later
- Swift 5.0 or later



## Installation

### Swift Package Manager

1. In Xcode, choose `File` > `Add Package dependencies...`
2. Enter the package repository URL

Enter the URL below and select `Add Package`.

```
https://github.com/naver/naveridlogin-sdk-ios-swift
```



### CocoaPods

1. Edit your `Podfile`

```Swift
# Podfile
use_frameworks!

target 'YOUR_APP_TARGET' do
	pod 'NidThirdPartyLogin'
end
```

Replace `YOUR_APP_TARGET` with the target that depends on the SDK.

2. Install the library

Run the command below to install the libraries listed in your `Podfile`.

```shell
$ pod install
```

3. Open the generated `xcworkspace` file and run the project



## Getting started with the sample app

To try out what the SDK offers, run the sample app as follows.

1. Clone the repository


```shell
$ git clone https://github.com/naver/naveridlogin-sdk-ios-swift
```

2. Open `NidThirdPartyLogin.xcworkspace` in Xcode

3. Select the `NidThirdPartyLoginSample` scheme and run




## License

```
Naver ID Login SDK for iOS Swift
Copyright (c) 2025-present NAVER Corp.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
