task :build do
  xcodebuild('build -scheme CGPathIntersection -destination generic/platform=iOS')
end

task :test do
  xcodebuild('test -scheme CGPathIntersection -destination "platform=iOS Simulator,name=iPhone 8"')
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
