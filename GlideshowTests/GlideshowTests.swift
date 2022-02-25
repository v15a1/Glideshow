//
//  GlideshowTests.swift
//  GlideshowTests
//
//  Created by Visal Rajapakse on 2021-02-28.
//

import XCTest
@testable import Glideshow

class GlideshowTests: XCTestCase {
    var glideshow : Glideshow!
    override func setUp() {
        glideshow = Glideshow()
    }
    
    func test_interval() {
        XCTAssertEqual(glideshow.interval, 0)
    }

    func test_slideMargin() {
        XCTAssertEqual(glideshow.slideMargin, UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
    }

    func test_slidePadding() {
        XCTAssertEqual(glideshow.slidePadding, UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
    }

    func test_defaultSldeColor() {
        XCTAssertEqual(glideshow.defaultSlideColor, .lightGray)
    }

    func test_placeHolderImage() {
        XCTAssertEqual(glideshow.placeHolderImage, nil)
    }

    func test_labelSpacing() {
        XCTAssertEqual(glideshow.labelSpacing, 8)
    }

    func test_isGradientEnabled() {
        XCTAssertEqual(glideshow.isGradientEnabled, false)
    }

    func test_titleFont() {
        XCTAssertEqual(glideshow.titleFont, UIFont.systemFont(ofSize: 20, weight: .black))
    }

    func test_descriptionGlideFactor() {
        XCTAssertEqual(glideshow.descriptionGlideFactor, 3)
    }

    func test_titleGlideFactor() {
        XCTAssertEqual(glideshow.titleGlideFactor, 2)
    }

    func test_captionGlideFactor() {
        XCTAssertEqual(glideshow.captionGlideFactor, 1)
    }

    func test_descriptionFont() {
        XCTAssertEqual(glideshow.descriptionFont, UIFont.systemFont(ofSize: 16, weight: .regular))
    }

    func test_captionFont() {
        XCTAssertEqual(glideshow.captionFont, UIFont.systemFont(ofSize: 14, weight: .light))
    }

    func test_titleColor() {
        XCTAssertEqual(glideshow.titleColor, .white)
    }

    func test_descriptionColor() {
        XCTAssertEqual(glideshow.descriptionColor, .white)
    }

    func test_captionColor() {
        XCTAssertEqual(glideshow.captionColor, .white)
    }

    func test_gradientColor() {
        XCTAssertEqual(glideshow.gradientColor, UIColor.black.withAlphaComponent(0.6))
        XCTAssertEqual(glideshow.isGradientEnabled, false)

        glideshow.gradientColor = .orange

        XCTAssertEqual(glideshow.gradientColor, .orange)
        XCTAssertEqual(glideshow.isGradientEnabled, true)
    }

    func test_gradientHeightFactor() {
        XCTAssertEqual(glideshow.gradientHeightFactor, 0.5)
        XCTAssertEqual(glideshow.isGradientEnabled, false)

        glideshow.gradientHeightFactor = 0.8

        XCTAssertEqual(glideshow.gradientHeightFactor, 0.8)
        XCTAssertEqual(glideshow.isGradientEnabled, true)

    }

    func test_pageIndicator() {
        XCTAssertEqual(glideshow.pageIndicator!.pageIndicatorTintColor, .lightGray)
        XCTAssertEqual(glideshow.pageIndicator!.currentPageIndicatorTintColor, .darkGray)
        XCTAssertEqual(glideshow.pageIndicator!.numberOfPages, 0)

        glideshow.items = [
            GlideItem(caption: "", title: "", description: "", backgroundImage: UIImage.checkmark),
            GlideItem(caption: "", title: "", description: "", backgroundImage: UIImage.checkmark)
        ]

        XCTAssertEqual(glideshow.pageIndicator!.numberOfPages, 2)
    }
    
    func test_setDescriptionGlideFactor() throws {
        let descriptionGlideFactor: CGFloat = 2.0
        glideshow.descriptionGlideFactor = descriptionGlideFactor
        XCTAssertEqual(glideshow.descriptionGlideFactor, descriptionGlideFactor)
    }

    func test_setTitleGlideFactor() throws {
        let titleGlideFactor: CGFloat = 1.0
        glideshow.titleGlideFactor = titleGlideFactor
        XCTAssertEqual(glideshow.titleGlideFactor, titleGlideFactor)
    }

    func test_setCaptionGlideFactor() throws {
        let captionGlideFactor: CGFloat = 3.0
        glideshow.captionGlideFactor = captionGlideFactor
        XCTAssertEqual(glideshow.captionGlideFactor, captionGlideFactor)
    }
}
