//
//  PhotoLibraryManager.swift
//  MyPhotos
//
//  Created by JK on 2021/07/20.
//

import Foundation
import Photos
import RxSwift
import UIKit

// MARK: - PhotoLibararyManager

final class PhotoLibararyManager {
  // iOS 14 에서 limit 권한인 경우 구분하기 위해 분리
  /// 사진 권한 요청.
  static func requstAuthorization() -> Completable {
    .create { subscriber in
      if #available(iOS 14, *) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
          if status == .authorized {
            subscriber(.completed)
          } else {
            subscriber(.error(PhotoLibraryError.accessDenied))
          }
        }
      } else {
        PHPhotoLibrary.requestAuthorization { status in
          if status == .authorized {
            subscriber(.completed)
          } else {
            subscriber(.error(PhotoLibraryError.accessDenied))
          }
        }
      }

      return Disposables.create()
    }
  }

  /// 모든 앨범들 목록을 가져옴.
  static func fetchAllAlbums() -> [PHAssetCollection] {
    let allPhotosOptions = PHFetchOptions()
    allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "endDate", ascending: true)]

    var list = [PHAssetCollection]()
    let recentAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: .none)
    let allAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: allPhotosOptions)

    recentAlbum.enumerateObjects { collection, _, _ in list.append(collection) }
    allAlbums.enumerateObjects { collection, _, _ in list.append(collection) }

    return list
  }

}

// MARK: - PhotoLibraryError

enum PhotoLibraryError: Error {
  case accessDenied
}
