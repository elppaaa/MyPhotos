//
//  PHPhotoCollection+Extension.swift
//  MyPhotos
//
//  Created by JK on 2021/07/20.
//

import Foundation
import Photos

extension PHAssetCollection {
  var fetchAssets: [PHAsset] {
    var assets = [PHAsset]()
    let options = PHFetchOptions()
    options.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: true)]

    PHAsset.fetchAssets(in: self, options: options)
      .enumerateObjects({ asset, _, _ in
        assets.append(asset)
      })

    return assets
  }
}
