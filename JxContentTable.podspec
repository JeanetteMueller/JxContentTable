#
# Be sure to run `pod lib lint JxContentTable.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JxContentTable'
  s.version          = '0.1.0'
  s.summary          = 'A Library to build up Content Table View Controllers withg a lot of different Cells.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  A Library to build up Content Table View Controllers withg a lot of different Cells. This helps to Build forms and content tables with ease.
                       DESC

  s.homepage         = 'https://github.com/JeanetteMueller/JxContentTable'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'JeanetteMueller' => 'themaverick@themaverick.de' }
  s.source           = { :git => 'https://github.com/JeanetteMueller/JxContentTable.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_versions = ['5.0', '5.1', '5.2', '5.3']
  s.source_files = 'Classes/**/*.swift', 'Classes/*.swift'
  
  s.resources = "JxContentTable/*.xib"
  s.resource_bundles = {
    'JxContentTable' => ['Classes/**/*.xib', 'Classes/*.xib']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit' #, 'MapKit'
  s.dependency 'ScrollableGraphView'
  s.dependency 'JxThemeManager'
  
  # s.dependency 'AFNetworking', '~> 2.3'
  
  s.pod_target_xcconfig = { 'APPLICATION_EXTENSION_API_ONLY' => 'NO' }
end
