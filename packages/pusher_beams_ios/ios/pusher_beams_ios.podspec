#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint pusher_beams.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'pusher_beams_ios'
  s.version          = '0.0.1'
  s.summary          = 'The iOS implementation from Pusher Beams for Flutter, intended to be a platform-specific package.'
  s.description      = <<-DESC
      Beams Flutter Plugin for iOS
                       DESC
  s.homepage         = 'http://pusher.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Pusher' => 'services@pusher.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.dependency 'PushNotifications', '~> 4.0'
end
