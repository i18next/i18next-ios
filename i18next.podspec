Pod::Spec.new do |s|
  s.name         = "i18next"
  s.version      = "1.0.1"
  s.summary      = "i18next internationalization library for iOS"
  s.homepage     = "https://github.com/i18next/i18next-ios"
  s.license      = "MIT"
  s.author       = { "Jean Regisser" => "jean.regisser@gmail.com" }
  s.source       = { :git => "https://github.com/i18next/i18next-ios.git", :tag => s.version }
  s.platform     = :ios, '5.0'
  s.source_files = 'src/*.{h,m}'
  s.requires_arc = true
end

