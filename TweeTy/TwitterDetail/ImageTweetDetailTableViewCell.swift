//
//  ImageTweetDetailTableViewCell.swift
//  TweeTy
//
//  Created by Ramon Schriks on 10-10-17.
//  Copyright © 2017 Ramon Schriks. All rights reserved.
//

import UIKit

class ImageTweetDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetImage: UIImageView!
    
    var imageLabel: UIImage? {
        didSet {
            var sourceImage = imageLabel
            sourceImage = sourceImage?.resizeImageWith(newSize: tweetImage.bounds.size)
            tweetImage.image = sourceImage
            tweetImage.sizeToFit()
        }
    }
}

extension UIImage{
    
    func resizeImageWith(newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
