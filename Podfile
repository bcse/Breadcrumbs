platform :ios, '7.0'
inhibit_all_warnings!

xcodeproj 'Breadcrumbs'

pod 'CocoaLumberjack', '~> 1.8.0'
pod 'Objective-LevelDB', '~> 2.0.5'

post_install do |installer|
    installer.project.targets.each do |target|
        puts target.name
    end
end
