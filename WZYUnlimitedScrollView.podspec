Pod::Spec.new do |s|

s.name         = "WZYUnlimitedScrollView"
s.version      = "1.0.1"
s.summary      = "WZYUnlimitedScrollView is a high degree of customization running on the iOS side of the automatic banner."
s.description  = <<-DESC
WZYUnlimitedScrollView is a high degree of customization running on the iOS side of the automatic banner. Support for local images and web images.You can listen to the picture click and rotate the pull-down drag pull zoom. Lightweight, easy integration.
DESC
s.homepage     = "https://github.com/CoderZYWang/WZYUnlimitedScrollView"
s.license      = "MIT"
s.author             = { "CoderZYWang" => "294250051@qq.com" }
s.social_media_url   = "http://blog.csdn.net/felicity294250051"
s.platform     = :ios
s.source       = { :git => "https://github.com/CoderZYWang/WZYUnlimitedScrollView.git", :tag => "1.0.1" }
s.source_files  = "WZYUnlimitScrollView/*.{h,m}"
s.frameworks = 'UIKit', 'Foundation'
s.requires_arc = true

end
