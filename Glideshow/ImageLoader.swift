//
//  ImageLoader.swift
//  Glideshow
//
//  Created by Visal Rajapakse on 2021-03-09.
//
//  Referenced from Maksym Shcheglov
//  https://medium.com/flawless-app-stories/reusable-image-cache-in-swift-9b90eb338e8d
//

import Foundation
import UIKit.UIImage
import Combine

public final class ImageLoader {
    public static let shared = ImageLoader()

    private let imageCache: ImageCacheType
    private lazy var backgroundQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()
    
    public init(cache: ImageCacheType = ImageCache()) {
        self.imageCache = cache
    }

    @available(iOS 13.0, *)
    public func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        if let image = imageCache[url] {
            return Just(image).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, response) -> UIImage? in return UIImage(data: data) }
            .catch { error in return Just(nil) }
            .handleEvents(receiveOutput: {[unowned self] image in
                guard let image = image else { return }
                self.imageCache[url] = image
            })
            .subscribe(on: backgroundQueue)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

var cache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImage(urlString: String) {
        
        if let cacheImage = cache.object(forKey: urlString as NSString) {
            self.image = cacheImage
            return
        }
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                return
            }
            
            guard let data = data else { return }
            let image = UIImage(data: data)
            cache.setObject(image!, forKey: urlString as NSString)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()

    }
}
