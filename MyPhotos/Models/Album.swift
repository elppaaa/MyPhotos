//
//  Album.swift
//  MyPhotos
//
//  Created by JK on 2021/07/20.
//

import Foundation
import Photos
/// 앨범에 대한 정보
struct Album {
  /**:
   `title`: 앨범 제목
   `recentPhoto`: 앨범 내 속해있는 `PHAsset` 중 가장 최근 Asset
   `count`: 앨범에 속해있는 이미지의 수
   `assetCollection`:  해당 앨범의 `PHAssetCollection` 인스턴스
   */

  let title: String?
  let recentPhoto: PHAsset?
  let count: Int

  let assetCollection: PHAssetCollection
}
