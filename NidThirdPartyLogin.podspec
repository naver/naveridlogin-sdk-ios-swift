Pod::Spec.new do |spec|
  spec.name         = "NidThirdPartyLogin"
  spec.version      = "5.1.0"
  spec.summary      = "Naver Login iOS SDK developed in Swift."
  spec.description  = "An iOS SDK designed to integrate Naver login into third-party apps."
  spec.homepage     = "https://developers.naver.com/docs/login/ios"

  spec.license      = { :type => "Apache-2.0", :file => "LICENSE" }

  spec.authors      = "NAVER"

  spec.platform     = :ios, "13.0"
  
  spec.source       = { :git => "https://github.com/naver/naveridlogin-sdk-ios-swift.git", :tag => "#{spec.version}" }
  spec.vendored_frameworks = "frameworks/*"

end
