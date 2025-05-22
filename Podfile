# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

def default_pods
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for IMT-iOS
  pod 'Alamofire'
  pod 'Toast-Swift', '~> 5.0.1'
  pod 'MaterialComponents/BottomSheet'
  pod 'KeychainSwift', '~> 20.0'
  pod 'SVProgressHUD', '~> 2.3.1'
  pod 'IQKeyboardManagerSwift'
  pod 'SwiftyJSON'
  pod 'SWXMLHash', '~> 7.0.0'
  pod 'CryptoSwift', '~> 1.8.0'
  pod 'MaterialComponents/Tabs+TabBarViewTheming'
end

target 'IMT-iOS DEV' do
  default_pods
end

target 'IMT-iOS STAG' do
  default_pods
end

target 'IMT-iOS PROD' do
  default_pods
end

target 'IMT TEST' do
  default_pods
end

target 'IMT-iOSTests' do
  inherit! :search_paths
  # Pods for testing
end

target 'IMT-iOSUITests' do
  # Pods for testing
end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end
    end
  end
end
