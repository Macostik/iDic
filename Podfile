# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'iDic' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'RealmSwift'
  pod 'Google/SignIn'
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'FacebookShare', :git => 'https://github.com/1amageek/facebook-sdk-swift'
  pod 'RxAlamofire'
  pod 'SnapKit', '~> 3.2.0'
  pod 'RxSwift', '~> 3.0'
  pod 'RxCocoa', '~> 3.0'
  pod 'Reachability', '3.2.0'
  pod 'lottie-ios'
  pod 'SwiftLint'
  pod 'SwiftyJSON'
  pod 'StreamView', :git => 'https://github.com/Macostik/StreamView.git'
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['SWIFT_VERSION'] = '3.0'
          end
      end
  end
end
