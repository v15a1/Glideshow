

![Frame 3](https://user-images.githubusercontent.com/46480892/110459021-74813d80-80f2-11eb-8dcf-620489289431.png)

# Glideshow
[![Generic badge](https://img.shields.io/badge/Swift-5.3-orange.svg)](https://shields.io/) [![Generic badge](https://img.shields.io/badge/iOS-13.0-blue.svg)](https://shields.io/)  [![Generic badge](https://img.shields.io/badge/Version-1.1.1-orange.svg)](https://shields.io/)  [![Generic badge](https://img.shields.io/badge/platform-ios-green.svg)](https://shields.io/)

A slideshow with *pizzazz!* Glideshow adds transitions to the slideshows labels to set it apart from other conventional "boring" slideshows,

![ezgif com-optimize](https://user-images.githubusercontent.com/46480892/128128971-f1dcb1bb-0339-448c-bd84-1f4f06213945.gif)

## Installation

#### CocoaPods

The Glideshow project is available via [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```
pod 'Glideshow'
```
#### Swift Package Manager

Add `https://github.com/v15a1/Glideshow` as a Swift Package in Xcode and follow the instructions.

## How to use

Add a Glideshow view to your view hiearchy by Interface Builder or programmatically

#### Loading images

The contents of the slideshow can be set with the use of `GlideItem` as demonstrated below. Further customizations can be configured as mentioned in the **Configuration** section

***NOTE : Setting the `glideFactor`to 0 will result in the labels being stationary***

```swift
// @IBOutlet weak var glideshow : Glideshow!
var glideshow = Glideshow()

glideshow.items = [ 
    GlideItem(title : "Hello there", description: "General Kenobi!", backgroundImage: UIImage(named:  "image1")),
    GlideItem(description: "General Kenobi!", backgroundImage: UIImage(named:  "image2")),
    GlideItem(title : "Hello there", backgroundImage: UIImage(named:  "image3")),
    GlideItem(title : "Hello there", description: "General Kenobi!")
    // Network images
    GlideItem(caption : "Hello there", description: "General Kenobi!", imageURL: "[ IMAGE URL ]")
]

```

## Configuration

The behaviour is configurable by the following properties

| Property | Description |
|----------|-------------|
| `interval` | Slideshow interval is seconds ( Default 0 ) |
| `isCircular` | Enables circular scrolling ( Default `true` )|
| `slideMargin` | Margin of the slides to the `UICollectionView` |
| `slidePadding` | Padding of the content |
| `defaultSlideColor` | Background color of the slides ( Default `UIColor.lightGray` ) |
| `labelSpacing` | Vertical spacing between labels within a slide ( Default 8 ) |
| `isGradientEnabled` | Displays gradient in the slide ( Default `false` ) |
| `gradientColor` | Base color of the gradient ( Default `UIColor.black.withAlphaComponent(0.6)`) |
| `gradientHeightFactor` | Height of the gradient based on slide height ( Default 0.5 ) |
| `titleFont` | Sets the `font` of the slide title |
| `descriptionFont` | Sets the `font` of the slide description |
| `captionFont` | Sets the `font` of the slide caption |
| `titleColor` | Sets the `textColor` of the slide title |
| `descriptionColor` | Sets the `textColor` of the slide description |
| `captionColor` | Sets the `textColor` of the slide slide caption |
| `titleGlideFactor` | Configures the speed of the transition of the title label ( Default 2 ) |
| `descriptionGlideFactor` | Configures the speed of the transition of the description label ( Default 3 ) |
| `captionGlideFactor` | Configures the speed of the transition of the caption label ( Default 1 ) |
| `pageIndicatorPosition` | Configures positon of the pge indicator |
| `placeHolderImage` | Configures slide background placeholder if a URL is specified, else `nil` |

### Contributions

A few issue to tackle
- [ ] Pass slide data through delegates
- [x] Support for Network images
- [ ] Multiple animations
- [ ] Customizable label positionings
- [ ] Code optimizations

Steps to contribution:

1. Fork the repo 
2. Clone the project
3. Make your changes
4. Make a pull request

If you have any question please feel free to open an issue

