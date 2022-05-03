Pod::Spec.new do |s|
  s.name = 'HasuraSDK'
  s.version = '1.0.0'
  s.license = { :type => 'Copyright', :file => 'LICENSE' }

  s.summary = 'Hasura SDK is a toolkit to work with Hasura servers easily.'
  s.homepage = 'https://relatedcode.com'
  s.author = { 'Related Code' => 'info@relatedcode.com' }

  s.source = { :git => 'https://github.com/relatedcode/HasuraSDK.git', :tag => s.version }

  s.ios.vendored_frameworks = 'HasuraSDK.xcframework'

  s.platform = :ios, '13.0'

  s.requires_arc = true
end
