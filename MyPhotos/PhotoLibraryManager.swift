//
//  PhotoLibraryManager.swift
//  MyPhotos
//
//  Created by JK on 2021/07/20.
//

import Foundation
import Photos
import RxSwift

final class PhotoLibararyManager {
  static let library = PHPhotoLibrary.shared()

  // iOS 14 에서 limit 권한인 경우 구분하기 위해 분리
  /// 사진 권한 요청.
  static func requstAuthorization() -> Completable {
    return .create { subscriber in
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

  static func fetchAllAlbums() -> Single<[PHAssetCollection]> {
    let allPhotosOptions = PHFetchOptions()
    allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "endDate", ascending: true)]

    return .create { subscriber in
      var list = [PHAssetCollection]()
      let recentAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumRecentlyAdded, options: .none)
      let allAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: allPhotosOptions)

      recentAlbum.enumerateObjects { collection, _, _ in list.append(collection) }
      allAlbums.enumerateObjects { collection, _, _ in list.append(collection) }

      subscriber(.success(list))

      return Disposables.create()
    }
    .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
  }

}

enum PhotoLibraryError: Error {
  case accessDenied
}
