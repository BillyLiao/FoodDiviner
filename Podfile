# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
# Uncomment this line if you're using Swift
use_frameworks!

target 'FoodDiviner' do
    pod 'TETinderPageView'
    pod 'AFNetworking', '~> 3.0'
    pod 'SwiftyJSON', '2.4.0'
    pod 'HCSStarRatingView', '~> 1.4.5'
    pod 'NVActivityIndicatorView', :git => 'https://github.com/ninjaprox/NVActivityIndicatorView.git', :branch => 'swift2.3'
    pod 'RealmSwift'
    pod 'DeviceKit', '~> 0.3.4'
    pod 'SDWebImage', '~>3.8'
    pod 'ZLSwipeableViewSwift'
    pod 'Firebase/Core'
    pod 'Firebase/Database'
    pod 'Firebase/Auth'
    
    # Always add this to podfile if you want to use old version of Swift.
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '2.3'
            end
        end
    end
end

target 'FoodDivinerTests' do

end

