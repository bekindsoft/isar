Pod::Spec.new do |s|
  s.name             = 'isar_flutter_libs'
  s.version          = '1.0.0'
  s.summary          = 'Flutter binaries for the Isar Database. Needs to be included for Flutter apps.'
  s.homepage         = 'https://isar.dev'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Isar' => 'hello@isar.dev' }

  s.source           = { :path => '.' }
  s.source_files     = 'isar_flutter_libs/Plugin/**/*.swift', 'isar_flutter_libs/Core/**/*.{h,c}'
  s.public_header_files = 'isar_flutter_libs/Core/include/**/*.h'

  s.ios.dependency 'Flutter'
  s.osx.dependency 'FlutterMacOS'
  s.ios.deployment_target = '12.0'
  s.osx.deployment_target = '10.14'
  s.swift_version = '5.3'
  s.vendored_frameworks = 'isar_flutter_libs/IsarCore.xcframework'
  s.frameworks = 'CoreFoundation', 'Security'
  s.resource_bundles = {'isar_flutter_libs_apple_privacy' => ['isar_flutter_libs/Plugin/PrivacyInfo.xcprivacy']}
end
