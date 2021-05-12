#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint onegini.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'onegini'
  s.version          = '0.1.0'
  s.summary          = 'Onegini Mobile Flutter plugin - iOS SDK'
  s.description      = <<-DESC
A flutter plugin project.
                       DESC
  s.homepage         = 'https://www.onegini.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Onegini B.V.' => 'info@onegini.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # ***************************
  s.dependency 'OneginiSDKiOS'
  s.requires_arc  = true
  # ***************************

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
