Pod::Spec.new do |spec|

  spec.name         = "Glideshow"
  spec.version      = "1.1.1"
  spec.summary      = "A slideshow written in Swift 5 that adds transitions to labels within a slide"

  spec.description  = <<-DESC
  This library allows developers to stray away from conventionals slideshows by adding transitions to the labels within the Slides
                   DESC

  spec.homepage     = "https://github.com/v15a1/Glideshow"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Visal Rajapakse" => "visalrajapakse@gmail.com" }

  spec.platform     = :ios, "11.0"
  spec.ios.deployment_target = "11.0"
  spec.swift_version = "5"

  spec.source       = { :git => "https://github.com/v15a1/Glideshow.git", :tag => "#{spec.version}" }
  spec.source_files  = "Glideshow", "Glideshow/**/*.{h,m}"
  spec.exclude_files = "GlideshowExample/**", "GlideshowTests/**"
end
