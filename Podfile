# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'iDic' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'RealmSwift'
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'FacebookShare', :git => 'https://github.com/1amageek/facebook-sdk-swift'
  pod 'Alamofire', '~> 4.0'
  pod 'SnapKit'
  pod 'SwiftyJSON'
  pod 'lottie-ios'
  pod 'StreamView', :git => 'https://github.com/Macostik/StreamView.git', :commit => '3cc6b1c3df76d709277a112fb1ad6a4630b0e556'
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['SWIFT_VERSION'] = '3.0'
          end
      end
  end
end
