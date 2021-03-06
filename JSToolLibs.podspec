#
# Be sure to run `pod lib lint JSToolLibs.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "JSToolLibs"
  s.version          = "0.1.2"
  s.summary          = "Tool Packages of iOS development."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                       This is the first time i try to make a tool repo for myself.
                       DESC

  s.homepage         = "https://github.com/jins33/JSToolLibs"
  # s.screenshots    = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "jins33" => "jinshengh33@outlook.com" }
  s.source           = { :git => "https://github.com/jins33/JSToolLibs.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.0'
  s.source_files = 'JSToolLibs/Classes/**/*'
  s.public_header_files = 'JSToolLibs/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
