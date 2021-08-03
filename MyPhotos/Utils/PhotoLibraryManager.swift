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
  /**
   사진 권한 요청.

   iOS 14.0 이후 버전에서 일부 사진만 선택한 경우, 모든 사진을 선택할 수 있도록 거절함.
   */
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

  /**
   모든 앨범 정보를 가져옴

   최근 순으로 정렬하여 모든 앨범 정보를 가져온다.
   */
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
