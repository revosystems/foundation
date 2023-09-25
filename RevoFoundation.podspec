# EXAMPLE / TUTORIAL: https://www.raywenderlich.com/5823-how-to-create-a-cocoapod-in-swift


Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.name         = "RevoFoundation"
  spec.version      = "0.2.13"
  spec.summary      = "Foundation utilities to be used across Revo projects."

  spec.description  = "A set of utilities that are used into Revo projects, it has some extensions and utilities that are not specific to any specifi business logic"

  spec.homepage     = "https://revo.works"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.license      = "MIT"
  spec.swift_version = "5.0"


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.author             = { "Jordi Puigdellívol" => "jordi@gloobus.net" }
  # Or just: spec.author    = "Jordi Puigdellívol"
  # spec.authors            = { "Jordi Puigdellívol" => "jordi@gloobus.net" }
  spec.social_media_url   = "https://instagram.com/badchoice2"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #  
  # spec.platform     = :ios
   #spec.platform     = :ios, "13.0"

  #  When using multiple platforms
   spec.ios.deployment_target = "13.0"
  # spec.osx.deployment_target = "13.7"
  # spec.watchos.deployment_target = "2.0"
  #spec.tvos.deployment_target = "13.0"

  spec.source       = { :git => "https://github.com/revosystems/foundation.git", :tag => "0.2.13" }
  spec.source_files  = "foundation/src/**/*.{swift}"#, "src/**/*.{h,m}"


end
