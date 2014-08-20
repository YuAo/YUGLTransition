Pod::Spec.new do |s|

  s.name         = "YUGLTransition"
  s.version      = "0.2.0"
  s.summary      = "OpenGL based transition for iOS. Based on GPUImage."

  s.description  = <<-DESC
                    The YUGLTransition is a library that lets you create GPU-based transition to UIView and UIViewController.

                    It uses GPUImage for the rendering part.

                    There're some ready-to-use transition effects, like ripple, swap, doorway, flash, flyeye, etc. And it allows you to create your own custom transitions by providing your custom transition filter.
                   DESC

  s.homepage     = "https://github.com/YuAo/YUGLTransition"
  s.license      = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author       = { "YuAo" => "me@imyuao.com" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/YuAo/YUGLTransition.git", :tag => "0.2.0" }
  s.source_files = 'YUGLTransition/**/*.{h,m}'
  s.frameworks = 'UIKit', 'Foundation'
  s.requires_arc = true

  s.dependency 'GPUImage'
end
