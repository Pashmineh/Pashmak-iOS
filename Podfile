# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Pashmak' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'IGListKit'
  pod 'Material'
  pod 'Hero'
  pod 'IQKeyboardManagerSwift'
  pod 'Hue'
  pod 'AsyncSwift'
  pod 'Locksmith'
  pod 'SecureNSUserDefaults'
  pod 'Log'
  pod 'KVNProgress'
  pod 'PromiseKit'
  pod 'SnapKit'
  pod 'KUIActionSheet' 
  pod 'RealmSwift'
  pod 'VisualEffectView'
  pod 'CHIPageControl/Jalapeno'
  pod 'FSPagerView'
  pod 'SkeletonView'
  pod 'lottie-ios'
  pod 'STRegex'
  pod 'SwiftLint'
  pod 'Kingfisher'
  pod 'SwiftDate'
  pod 'ParticlesLoadingView'
  pod 'BulletinBoard' #, :path => '../BulletinBoard/'
  pod 'RxKeyboard'
  pod 'TextImageButton', :git => 'https://github.com/mohpor/TextImageButton.git', :branch => 'material'
 
inhibit_all_warnings!


post_install do |installer|
  oldTargets = ["Hero", "BulletinBoard"]
  installer.pods_project.targets.each do |target|
    if oldTargets.include? target.name
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.1'
      end
    end
  end
end
end
