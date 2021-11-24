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
  s.static_framework = true
  
  
  s.subspec 'JPVideoEdit' do |VE|
    VE.vendored_frameworks = 'Funcation/JPSDK/JPVideoEdit.framework'
    VE.resource = 'Funcation/JPSDK/JPResource.bundle'
    VE.dependency 'SDCycleScrollView'
    VE.dependency 'SDAutoLayout'
    VE.dependency 'MBProgressHUD'
    VE.dependency 'Masonry'
    VE.dependency 'FMDB'
    VE.dependency 'MJRefresh'
    VE.dependency 'GPUImage'
  end
  
  s.subspec 'JPUMaterialSDK' do |UM|
    UM.resource = 'Funcation/JPUMaterialSDK/JPUMaterialSDK/JPUEditVideoImageBundle.bundle'
    UM.source_files = 'Funcation/JPUMaterialSDK/JPUMaterialSDK/*.{h,m}'
       UM.dependency "AFNetworking"
       UM.dependency "SDWebImage"
       UM.dependency "MJExtension"
       UM.dependency "QMUIKit/QMUIComponents/QMUIAssetLibrary","~> 4.3.0"
       UM.dependency "ZFPlayer/AVPlayer","~> 4.0.2"
       UM.dependency "ZFPlayer/ControlView","~> 4.0.2"
       UM.dependency "UICountingLabel"
       UM.dependency "MBProgressHUD"
       UM.dependency "QCloudCOSXML","~> 5.6.6"
  end
  
  s.subspec 'JPLive' do |LE|
  
        LE.prefix_header_file = false
          LE.prefix_header_file = 'Funcation/JPLive/JPLive/Base/Model/JPLPrefix.pch'
        LE.source_files = "Funcation/JPLive/JPLive/**/*.{h,m}"
        LE.resource = 'Funcation/JPLive/JPLive/Resource/JPLResource.bundle'
                  LE.dependency 'TXLiteAVSDK_Smart','9.2.10637'
          LE.dependency 'Masonry'
          LE.dependency 'MJRefresh'
          LE.dependency 'MJExtension'
         LE.dependency 'IQKeyboardManager'
          LE.dependency 'AFNetworking'
          LE.dependency 'MBProgressHUD'
          LE.dependency 'SDWebImage'
          LE.dependency 'DZNEmptyDataSet'
          LE.dependency 'SDAutoLayout'
          LE.dependency 'YYText'
  
  end

end
