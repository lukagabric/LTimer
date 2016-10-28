Pod::Spec.new do |spec|
  spec.name         = 'LTimer'
  spec.version      = '1.0'
  spec.license      = 'MIT'
  spec.summary      = 'iOS Timer'
  spec.homepage     = 'https://github.com/lukagabric/LTimer'
  spec.author       = 'Luka Gabric'
  spec.source       = { :git => 'git://github.com/lukagabric/LTimer' }
  spec.source_files = 'LTimer/LTimer/Classes/Core/LTimer/*.{m,h,mm,hpp,cpp,c}'
  spec.requires_arc = true
end
