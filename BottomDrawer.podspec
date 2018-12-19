#
# Be sure to run `pod lib lint BottomDrawer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BottomDrawer'
  s.version          = '0.1.0'
  s.summary          = 'iOS component which presents a dismissible view from the bottom of the screen'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'BottomDrawer is an iOS component which presents a dismissible view from the bottom of the screen. BottomDrawer can be a useful replacement for popups and menus but can hold any viewcontroller so the use cases are endless. This repository includes the BottomDrawer component itself but also includes an extension for autolayout (NSLayoutConstraint)'

  s.homepage         = 'https://github.com/sagaya/BottomDrawer'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sagaya' => 'shaggy.hafeez@gmail.com' }
  s.source           = { :git => 'https://github.com/sagaya/BottomDrawer.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/sagaya_hafeez'

  s.ios.deployment_target = '9.0'

  s.source_files = 'BottomDrawer/Classes/**/*'
  
   s.resource_bundles = {
     'BottomDrawer' => ['BottomDrawer/Assets/*.xcassets']
   }
  s.frameworks = 'UIKit', 'MapKit'
end
