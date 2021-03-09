//
//  GlideItem.swift
//  Glideshow
//
//  Created by Visal Rajapakse on 2021-02-28.
//

import UIKit

public struct GlideItem {
    
    /// Caption of the slide
    public var caption : String!
    
    /// Title of the slide
    public var title : String!
    
    /// Description of the slide
    public var description : String!
    
    /// Asset image for slide background
    public var backgroundImage : UIImage?
    
    public var imgURL : String?
    
    /// Initializer for GlideItem
    ///
    /// - Parameters:
    ///   - caption: Caption of the slide
    ///   - title: Title of the slide
    ///   - description: Description of the slide
    ///   - backgroundImage: Image asset to display in the slide background
    public init(
        caption : String! = nil, 
        title : String! = nil,
        description : String! = nil,
        backgroundImage : UIImage! = nil
    ){
        self.caption = caption
        self.title = title
        self.description = description
        self.backgroundImage = backgroundImage
    }
    
    /// Initializer for GlideItem
    ///
    /// - Parameters:
    ///   - caption: Caption of the slide
    ///   - title: Title of the slide
    ///   - description: Description of the slide
    ///   - imageURL: Image URL to load
    public init(
        caption : String! = nil,
        title : String! = nil,
        description : String! = nil,
        imageURL : String! = nil
    ){
        self.caption = caption
        self.title = title
        self.description = description
        self.imgURL = imageURL
    }
}
