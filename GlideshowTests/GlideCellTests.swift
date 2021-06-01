//
//  GlideCellTests.swift
//  GlideshowTests
//
//  Created by Jesus Andres Bernal Lopez on 6/1/21.
//

import XCTest
@testable import Glideshow

class GlideCellTests: XCTestCase {

    func test_configureWithBackgroundImage() {
        let cell = GlideCell()
        
        let testItem = GlideItem(caption: "a-caption", title: "a-title", description: "a-description", backgroundImage: UIImage.checkmark)
        
        cell.configure(with: testItem, placeholderImage: nil)
        
        XCTAssertEqual(cell.slideCaption.text, testItem.caption)
        XCTAssertEqual(cell.slideTitle.text, testItem.title)
        XCTAssertEqual(cell.slideDescription.text, testItem.description)
        XCTAssertEqual(cell.backgroundImage, testItem.backgroundImage)
    }
    
    func test_configureWithImageURL() {
        let cell = GlideCell()
        
        let testItem = GlideItem(caption: "a-caption", title: "a-title", description: "a-description", imageURL: "a-url")

        let placeholderImage = UIImage.checkmark
        
        cell.configure(with: testItem, placeholderImage: placeholderImage)
        
        XCTAssertEqual(cell.slideCaption.text, testItem.caption)
        XCTAssertEqual(cell.slideTitle.text, testItem.title)
        XCTAssertEqual(cell.slideDescription.text, testItem.description)
        XCTAssertEqual(cell.backgroundImage, placeholderImage)
    }

}
