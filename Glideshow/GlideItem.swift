//
//  GlideItem.swift
//  Glideshow
//
//  Created by Visal Rajapakse on 2021-02-28.
//

import UIKit

public class GlideItem {
    
    /// Caption of the slide
    private var caption : String!
    
    /// Title of the slide
    private var title : String!
    
    /// Description of the slide
    private var description : String!
    
    /// Asset image for slide background
    private var backgroundImage : UIImage?

    /// Image url
    private var imageURL : String?
    
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
    ) {
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
    ///   - imageURL: URL string for network images
    public init(
        caption : String! = nil,
        title : String! = nil,
        description : String! = nil,
        imageURL : String! = nil)
    {
        self.caption = caption
        self.title = title
        self.description = description
        self.imageURL = imageURL
    }
    
}
