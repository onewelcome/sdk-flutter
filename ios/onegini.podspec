#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint onegini.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'onegini'
  s.version          = '1.2.1'
  s.summary          = 'Onegini Mobile Flutter plugin'
  s.description      = <<-DESC
  The Onegini Flutter Plugin is a plugin that allows you to utilize the Onegini Mobile SDKs in your Flutter applications.
                       DESC
  s.homepage         = 'https://www.onegini.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Onegini B.V.' => 'info@onegini.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # ***************************
  s.dependency 'OneginiSDKiOS', '~> 12.2.0'
  # ***************************

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
