//
//  PHAsset+Extension.swift
//  MyPhotos
//
//  Created by JK on 2021/07/20.
//

import Foundation
import Photos
import UIKit.UIImage
import RxSwift

extension PHAsset {
  var fileName: String? {
    let resources = PHAssetResource.assetResources(for: self)
    guard let resource = resources.first else { return nil }

    return resource.originalFilename
  }

  var fileSize: Float? {
    let resources = PHAssetResource.assetResources(for: self)
    guard let size = resources.first?.value(forKey: "fileSize") as? Int else { return nil }
    return Float(size) / (1024.0 * 1024.0)
  }

  func image(size: CGSize) -> UIImage? {
    var image: UIImage?
    let scale = UIScreen.main.scale

    let manager = PHImageManager.default()
    let option = PHImageRequestOptions()
    option.deliveryMode = .opportunistic
    option.resizeMode = .fast
    let preferredSize = CGSize(width: size.width * scale, height: size.height * scale)
    manager.requestImage(for: self, targetSize: preferredSize, contentMode: .default, options: option) { _image, _ in
      image = _image
    }

    return image
  }

}
