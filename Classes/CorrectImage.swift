//
//  CorrectImage.swift
//  ProfileApp
//
//  Created by Александр Федоткин on 04.12.2023.
//

import Foundation
import UIKit

class CorrectImage {
    
    static func cropToSquare(image originalImage: UIImage) -> UIImage {
        let originalWidth  = originalImage.size.width
        let originalHeight = originalImage.size.height

        let cropSquare = CGRect(x: (originalWidth - min(originalWidth, originalHeight)) / 2,
                                y: (originalHeight - min(originalWidth, originalHeight)) / 2,
                                width: min(originalWidth, originalHeight),
                                height: min(originalWidth, originalHeight))
        
        let imageRef = originalImage.cgImage!.cropping(to: cropSquare)

        return UIImage(cgImage: imageRef!, scale: UIScreen.main.scale, orientation: originalImage.imageOrientation)
    }
}
