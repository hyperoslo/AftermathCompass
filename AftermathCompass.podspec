Pod::Spec.new do |s|
  s.name             = "AftermathCompass"
  s.summary          = "Message-driven navigation system built on top of Aftermath and Compass."
  s.version          = "0.1.0"
  s.homepage         = "https://github.com/hyperoslo/AftermathCompass"
  s.license          = 'MIT'
  s.author           = {
    "Hyper Interaktiv AS" => "ios@hyper.no"
  }
  s.source           = {
    :git => "https://github.com/hyperoslo/AftermathCompass.git",
    :tag => s.version.to_s
  }
  s.social_media_url = 'https://twitter.com/hyperoslo'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '9.2'

  s.requires_arc = true
  s.source_files = 'Sources/**/*'

  s.frameworks = 'Foundation'
  s.dependency 'Aftermath'
  s.dependency 'Compass'
end
