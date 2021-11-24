Pod::Spec.new do |s|
  s.name     = 'JPLive'
  s.version  = '0.0.1'
  s.license  = 'BSD'
  s.summary  = 'JPLive.'
  s.homepage = 'https://github.com/RRRenJ/JPLive'
  s.author   = { 'RRRenj' => '584201474@qq.com' }
  s.source   = { :git => 'https://github.com/RRRenJ/JPLive.git', :tag => "#{s.version}" }
#  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.prefix_header_file = false
  s.prefix_header_file = 'JPLive/Base/Model/JPLPrefix.pch'
 
  s.source_files = "JPLive/**/*.{h,m}"
  s.resource = "JPLive/Resource/JPLResource.bundle"
  s.requires_arc = true
  s.xcconfig = { 'CLANG_MODULES_AUTOLINK' => 'YES' }
  
  s.ios.deployment_target = '10.0'
  s.ios.frameworks   = ['AVFoundation']
  s.static_framework = true
  
  s.dependency 'TXLiteAVSDK_Smart','9.2.10637'
  s.dependency 'Masonry'
  s.dependency 'MJRefresh'
  s.dependency 'MJExtension'
  s.dependency 'IQKeyboardManager'
  s.dependency 'AFNetworking'
  s.dependency 'MBProgressHUD'
  s.dependency 'SDWebImage'
  s.dependency 'DZNEmptyDataSet'
  s.dependency 'SDAutoLayout'
  s.dependency 'YYText'
  
 
end
