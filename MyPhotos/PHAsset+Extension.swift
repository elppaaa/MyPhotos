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

  var fileName: String? {
    let resources = PHAssetResource.assetResources(for: self)
    guard let resource = resources.first else { return nil }

    return resource.originalFilename
  }

  var fileSize: Float? {
    let resource = PHAssetResource.assetResources(for: self)
    guard let size = resource.first?.value(forKey: "fileSize") as? Float else { return nil }
    return size / (1024.0*1024.0)
  }
  
}
