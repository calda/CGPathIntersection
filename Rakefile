namespace :build do
  task :iOS do
    xcodebuild('build -scheme CGPathIntersection-iOS -destination generic/platform=iOS')
  end
  task :macOS do
    sh 'swift build'
  end
  task :tvOS do
    xcodebuild('build -scheme CGPathIntersection-tvOS -destination generic/platform=tvOS')
  end
end

namespace :test do
  task :iOS do
    xcodebuild('test -scheme CGPathIntersection-iOS -destination "platform=iOS Simulator,name=iPhone 12"')
  end
  task :macOS do
    sh 'swift test'
  end
  task :tvOS do
    xcodebuild('test -scheme CGPathIntersection-tvOS -destination "platform=tvOS Simulator,name=Apple TV"')
  end
end

namespace :lint do
  desc 'Lints the CocoaPods podspec'
  task :podspec do
    sh 'pod lib lint CGPathIntersection.podspec'
  end
end

def xcodebuild(command)
  sh "set -o pipefail && xcodebuild #{command} | mint run xcbeautify"
end
