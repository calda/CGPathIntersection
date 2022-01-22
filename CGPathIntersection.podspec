Pod::Spec.new do |s|
  s.platform              = :ios, "10.0"
  s.name                  = "CGPathIntersection"
  s.version               = "3.1"
  s.summary               = "An iOS library that identifies points where two CGPaths intersect"
  s.homepage              = "https://github.com/calda/CGPathIntersection"
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { "Cal Stephens" => "cal@calstephens.tech" }
  s.source                = { :git => 'https://github.com/calda/CGPathIntersection.git', :tag => '3.1' }
  s.source_files          = 'CGPathIntersection/*.swift'
  s.exclude_files         = 'README.md', 'LICENSE.md', 'CGPathIntersection.podspec', 'images/*'
  s.requires_arc          = true
end
