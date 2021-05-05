
import Foundation
import UIKit

class ImageCacher {
    
    static let sharedImageCacher = ImageCacher()
    private var imageCache = NSCache<NSString, UIImage>()
    
    private init() {
    }
    
    func loadImageFromUrl(urlString: String, imageView:UIImageView) {
        
        imageView.image = UIImage(named: "thumb-image")
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            imageView.image = imageFromCache
        } else {
            guard let url = URL(string: urlString) else { return }
            URLSession.shared.dataTask(with:url) { [weak self] (data, response, error) in
                if let response = data, let imageToCache = UIImage(data: response)   {
                    self?.imageCache.setObject(imageToCache, forKey: urlString as NSString)
                    DispatchQueue.main.async {
                        imageView.image = imageToCache
                    }
                }
            }.resume()
        }
    }
}
