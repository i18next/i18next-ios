Pod::Spec.new do |s|
  s.name         = "i18next"
  s.version      = "0.2.9"
  s.summary      = "i18next translation library for objc"
  s.homepage     = "https://github.com/preplay/i18next-ios"
  s.license      = "MIT"
  s.author       = { "Jean Regisser" => "jean.regisser@gmail.com" }
  s.source       = { :git => "https://github.com/preplay/i18next-ios.git" }
  s.platform     = :ios, '5.0'
  s.source_files = 'src/*.{h,m}'
  s.requires_arc = true
end

