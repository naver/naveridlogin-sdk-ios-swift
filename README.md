# Naver ID Login SDK for iOS Swift

iOS용 네이버 아이디로 로그인 SDK 및 샘플 프로젝트입니다. 

서드파티 앱에서 네이버 아이디로 로그인이 제공하는 로그인, 로그아웃, 토큰 관리 등의 기능을 쉽게 구현할 수 있습니다.



자세한 내용은 [개발자 센터 튜토리얼](https://developers.naver.com/docs/login/ios/ios.md)에서 확인하실 수 있습니다.

## 요구사항

- iOS 13.0 이상
- Xcode 16.0 이상
- Swift 5.0 이상



## 설치

### Swift Package Manager

1. Xcode의 `File` 메뉴 선택 > `Add Package dependencies...` 
2. 패키지 레포지토리(repository) URL 입력

아래 URL을 입력한 후 `Add Package`를 선택합니다.

```
https://github.com/naver/naveridlogin-sdk-ios-swift
```



### CocoaPods

1. `Podfile` 수정

```Swift
# Podfile
use_frameworks!

target 'YOUR_APP_TARGET' do
	pod 'NidThirdPartyLogin'
end
```

`YOUR_APP_TARGET` 에는 네아로 SDK 의존성을 추가할 타겟을 작성합니다.

2. 라이브러리 설치

아래 명령어를 입력해 `Podfile`에 작성된 라이브러리를 설치합니다.

```shell
$ pod install
```

3. `xcworkspace` 파일을 열어 프로젝트 실행



## 샘플앱 시작하기

네이버 아이디로 로그인 SDK에서 제공하는 기능을 빠르게 확인해보려면 아래 단계에 따라 샘플 앱을 실행해보세요.

1. Git 저장소 복제


```shell
$ git clone https://github.com/naver/naveridlogin-sdk-ios-swift
```

2. Xcode에서 `NidThirdPartyLogin.xcworkspace` 파일 열기

3. NidThirdPartyLoginSample` 스킴 선택 및 실행




## 라이선스

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
