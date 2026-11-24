# Define a global platform for your project
platform :ios, '12.0'

target 'ProviderApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  # use_frameworks!

  # Pods for ProviderApp
  pod 'GoogleMaps'
  pod 'SDWebImage/GIF'
  pod 'GoogleSignIn'
  pod 'Fabric', '~> 1.10.2'
  pod 'Crashlytics', '~> 3.14.0'
  pod 'Firebase/Analytics'
  pod 'Firebase/CoreOnly'
  pod 'Firebase/Database'
  pod 'Firebase/Messaging'
  pod 'SinchRTC'
  pod 'CardIO'
  pod 'Firebase/Crashlytics'
  
  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'
  pod 'FBSDKShareKit'
  pod 'CropViewController'
#  pod 'HandyJSON', :git => 'https://github.com/alibaba/HandyJSON.git', :branch => 'master'
  # pod 'Xendit', '3.0.0-beta'
  pod 'IQKeyboardManagerSwift'
  pod 'NVActivityIndicatorView'
  pod 'RaveSDK'
  pod 'LiveChat', '~> 2.0.20'
  pod 'Charts', '~> 4.1.0'
  pod 'GoogleWebRTC', '~> 1.0'

  target 'ProviderAppTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ProviderAppUITests' do
    # Pods for testing
  end
end

# Force all pods to use iOS 12.0 deployment target
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
