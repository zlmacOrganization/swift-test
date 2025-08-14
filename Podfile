platform :ios, ‘13.0’
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'

#error: PMS/xx.framework does not support provisioning profiles
#post_install do |installer|
#  installer.pods_project.targets.each do |target|
#    target.build_configurations.each do |config|
#      config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
#      config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
#      config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
#    end
#  end
#end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end

#post_install do |installer|
#​
#  installer.aggregate_targets.each do |target|
#    target.xcconfigs.each do |variant, xcconfig|
#      xcconfig_path = target.client_root + target.xcconfig_relative_path(variant)
#      IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
#    end
#  end
#
#    ​installer.generated_projects.each do |project|
#    target.build_configurations.each do |config|
#      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
#​
#      if config.base_configuration_reference.is_a? Xcodeproj::Project::Object::PBXFileReference
#        xcconfig_path = config.base_configuration_reference.real_path
#        IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
#      end
#    end
#end

target ‘SwiftTest’ do
    
#pod 'ZLMacPod', :git => 'https://github.com/zlmac/ZLMacPod.git'
    
pod 'Alamofire', '~> 5.9.1'
#pod 'PromiseKit', '~> 4.0'
pod 'Kingfisher', '~> 7.11.0'
pod 'SnapKit', '~> 5.7.1'
pod 'SQLite.swift', '~> 0.15.1'
#pod 'SwiftProgressHUD'
#pod 'ReactiveCocoa'
#pod 'HandyJSON', '~> 4.2.0'
pod 'HandyJSON', :git => 'https://github.com/alibaba/HandyJSON.git', :branch => 'dev_for_swift5.0'

pod 'SwiftyJSON', '~> 5.0.2'

pod 'FSPagerView'
pod 'SwiftPullToRefresh'
#pod 'SKPhotoBrowser'
#pod 'AXPhotoViewer'
pod 'ZLPhotoBrowser', '~> 4.5.1'
#pod "Texture"

pod 'JXPagingView/Paging'
pod 'JXSegmentedView'

pod 'SwiftLint'
#pod 'SwiftGen'

pod 'IQKeyboardManagerSwift'

#pod 'WoodPeckeriOS', :configurations => ['Debug']

pod 'TZImagePickerController', :git => 'https://github.com/zlmac/TZImagePickerController.git'

#pod 'AMap3DMap'
#pod 'AMapSearch'
#pod 'AMapLocation'

#pod 'RxSwift',    '~> 4.0'
#pod 'RxCocoa',    '~> 4.0'

#pod 'TimedSilver', '1.1.0'

pod 'SwiftyRSA'
#pod 'lottie-ios'
#pod 'CropViewController'

#https://github.com/longitachi/ZLImageEditor
#pod 'ZLImageEditor'
#pod 'BSText'

#pod 'SpecLeaks'
#pod 'EFQRCode', '~> 7.0.2'
#pod 'Reaper', :git => 'https://github.com/getsentry/Reaper-iOS.git'

end
