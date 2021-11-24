Pod::Spec.new do |s|
  s.name     = 'JPFuncation'
  s.version  = '0.0.1'
  s.license  = 'BSD'
  s.summary  = 'JPFuncation.'
  s.homepage = 'https://github.com/RRRenJ/JPLive'
  s.author   = { 'RRRenj' => '584201474@qq.com' }
  s.source   = { :git => 'https://github.com/RRRenJ/JPLive.git', :tag => "#{s.version}" }

  s.source_files = "JPFuncation/**/*.{h,m}"
  s.resource = "JPFuncation/Resource/JPFResource.bundle"
  s.requires_arc = true
  s.xcconfig = { 'CLANG_MODULES_AUTOLINK' => 'YES' }
  
  s.ios.deployment_target = '10.0'
  s.ios.frameworks   = ['AVFoundation']
  
  s.dependency 'JPVideoEdit'
  s.dependency 'JPLive'
  s.dependency 'JPUMaterialSDK'

  
 
end
