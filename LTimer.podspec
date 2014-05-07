Pod::Spec.new do |s|
  s.name         = "LTimer"
  s.version      = "1.0"
  s.summary      = "iOS Timer"
  s.platform     = :ios, '6.0'
  s.homepage     = "https://github.com/lukagabric/LTimer"
  s.source       = { :git => 'https://github.com/lukagabric/LTimer'}
  s.source_files = 'LTimer/LTimer/Classes/Core/LTimer/*.{h,m}'
  s.requires_arc = true
end