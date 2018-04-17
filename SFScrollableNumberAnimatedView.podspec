
Pod::Spec.new do |s|
  s.name         = "SFScrollableNumberAnimatedView"
  s.version      = "0.1.0"
  s.summary      = "A vertical scroll animation view for display math numbers for iOS."
  s.description  = <<-DESC
                    animated scroll number view. integer, float and negative number are surpported, easy to use
                   DESC

  s.homepage     = "https://github.com/sffernando/SFScrollableNumberAnimatedView.git"
  s.screenshots  = "https://github.com/sffernando/SFScrollableNumberAnimatedView/blob/master/demo.gif"
  s.license      = "MIT"
  s.author       = { "Fernando" => "sucrezhang@qq.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/sffernando/SFScrollableNumberAnimatedView.git", :tag => s.version }
  s.source_files  = "SFScrollableNumberAnimatedView/SFScrollableNumberAnimatedView/Source/*.{h,m}"
  s.exclude_files = "SFScrollableNumberAnimatedView/SFScrollableNumberAnimatedView.h"

end
