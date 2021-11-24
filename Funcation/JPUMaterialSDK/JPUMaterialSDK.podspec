#
#  Be sure to run `pod spec lint JPUMaterialSDK.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "JPUMaterialSDK"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of JPUMaterialSDK."


  spec.description  = <<-DESC
                    SDKSDKSDK
                   DESC

  spec.homepage     = "http://EXAMPLE/JPUMaterialSDK"



  spec.author             = { "chenfeiyu" => "18111177127@163.com" }

 

   spec.platform     = :ios
   spec.platform     = :ios, "10.0"




  spec.source       = { :git => "https://gitee.com/cures/jpumaterial-edit-moudel.git", :tag => "#{spec.version}" }



  spec.source_files  = "JPUMaterialSDK/**/*.{h,m}"
  spec.exclude_files = "Classes/Exclude"

  spec.static_framework = true


 
    spec.resource  = "JPUMaterialSDK/JPUEditVideoImageBundle.bundle"




 spec.dependency "AFNetworking"
   spec.dependency "SDWebImage"
   spec.dependency "MJExtension"
   spec.dependency "QMUIKit/QMUIComponents/QMUIAssetLibrary","~> 4.3.0"
   spec.dependency "ZFPlayer/AVPlayer","~> 4.0.2"
   spec.dependency "ZFPlayer/ControlView","~> 4.0.2"
   spec.dependency "UICountingLabel"
   spec.dependency "MBProgressHUD"
   spec.dependency "QCloudCOSXML","~> 5.6.6"


end
