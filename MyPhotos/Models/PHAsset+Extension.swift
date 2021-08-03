//
//  PHAsset+Extension.swift
//  MyPhotos
//
//  Created by JK on 2021/07/20.
//

import Foundation
import Photos
import RxSwift
import UIKit.UIImage

extension PHAsset {
  static let fetchScheduler = ConcurrentDispatchQueueScheduler(qos: .userInitiated)

  /// PHAsset  원본 파일의 이름
  var fileName: String? {
    let resources = PHAssetResource.assetResources(for: self)
    guard let resource = resources.first else { return nil }

    return resource.originalFilename
  }

  /// PHAsset  원본 파일의 원본 파일 사이즈
  var fileSize: Float? {
    let resources = PHAssetResource.assetResources(for: self)
    guard let size = resources.first?.value(forKey: "fileSize") as? Int else { return nil }
    return Float(size) / (1024.0 * 1024.0)
  }
}

extension Reactive where Base: PHAsset {
  /**
   이미지를 가져온다.

   PHAsset 에서 이미지는 여러번 받아올 수 있음. 최대 두번 방출 후 종료.

   - Parameters:
     - size: 받아올 이미지의 크기를 지정.
   */
  func image(size: CGSize) -> Observable<UIImage?> {
    .create { subscriber in
      let scale = UIScreen.main.scale
      let manager = PHImageManager.default()
      let option = PHImageRequestOptions()
      option.deliveryMode = .opportunistic
      option.resizeMode = .exact

      let preferredSize = CGSize(width: size.width * scale, height: size.height * scale)
      manager.requestImage(for: base, targetSize: preferredSize, contentMode: .default, options: option) { _image, _ in
        if let _image = _image {
          subscriber.onNext(_image)
        }
      }

      return Disposables.create()
    }
    .subscribe(on: PHAsset.fetchScheduler)
    .take(2)
  }
}
