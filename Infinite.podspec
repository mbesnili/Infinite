#
#  Be sure to run `pod spec lint Infinite.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "Infinite"
  s.version      = "0.0.1"
  s.summary      = "A short description of Infinite."
  s.description  = "Infinite Table View Controller"
  s.homepage     = "https://github.com/mbesnili/Infinite"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author    = "mbesnili"
  s.social_media_url   = "http://twitter.com/mbesnili"
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/mbesnili/Infinite.git", :tag => "#{s.version}" }
  s.framework    = "UIKit"
  s.source_files = "Infinite/*.{swift}"

end
