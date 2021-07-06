# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

# Remove deployment target for each pod
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end

target 'mycard' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for mycard
  # firebase pods
  pod 'GoogleMLKit/TextRecognition'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'FirebaseFirestoreSwift', '~> 7.0-beta'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Analytics'
  
  # pod for CropImage
  pod 'CropViewController'

  #pods for rxswift
  #pod 'RxSwift'
  pod 'RxCocoa'
  
  #pods for keychain
  pod 'KeychainAccess'
  
  #pod for swiftQueue
  #pod 'SwiftQueue'
  
  #pod for hero animation
  pod 'Hero'

  #pod for tooltip
  pod 'EasyTipView', '~> 2.1'
  
  #country picker
  pod 'SKCountryPicker'
  
  pod 'MSPeekCollectionViewDelegateImplementation'
  
  # ignore all warnings from all dependencies
  inhibit_all_warnings!

#  target 'mycardTests' do
#    inherit! :search_paths
#    # Pods for testing
#  end
#
#  target 'mycardUITests' do
#    # Pods for testing
#  end

end
