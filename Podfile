platform :ios, '16.0' 

target 'GeoRocksIOS' do
  use_frameworks! :linkage => :static

  pod 'Alamofire', '~> 5.6'
  pod 'SDWebImage', '~> 5.20'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['DEVELOPMENT_TEAM'] = '5U753FXZ82'
    end
  end
end
