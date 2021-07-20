//
//  PHAsset+Extension.swift
//  MyPhotos
//
//  Created by JK on 2021/07/20.
//

import Foundation
import Photos
import UIKit.UIImage

extension PHAsset {
  func image(size: CGSize) -> UIImage? {
    var image: UIImage?
    let manager = PHImageManager.default()
    manager.requestImage(for: self, targetSize: size, contentMode: .aspectFit, options: nil) { _image, _ in
      image = _image
    }

    return image
  }
}
