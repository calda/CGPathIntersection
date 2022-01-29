Pod::Spec.new do |s|
  s.swift_version = '5.1'
  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '10.0'
  s.name                  = "CGPathIntersection"
  s.version               = "4.0"
  s.summary               = "An iOS library that identifies points where two CGPaths intersect"
  s.homepage              = "https://github.com/calda/CGPathIntersection"
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { "Cal Stephens" => "cal@calstephens.tech" }
  s.source                = { :git => 'https://github.com/calda/CGPathIntersection.git', :tag => '4.0' }
  s.source_files          = 'CGPathIntersection/*.swift'
  s.exclude_files         = 'README.md', 'LICENSE.md', 'CGPathIntersection.podspec', 'images/*'
  s.requires_arc          = true
end
