//
//  AlbumViewModel.swift
//  MyPhotos
//
//  Created by JK on 2021/07/20.
//

import Foundation
import Photos
import RxRelay
import RxSwift
import UIKit.UIImage

// MARK: - AlbumViewModelType

protocol AlbumViewModelType {
  var input: AlbumViewModelTypeInput { get }
  var output: AlbumViewModelTypeOutput { get }
}

// MARK: - AlbumViewModelTypeInput

protocol AlbumViewModelTypeInput {
  func getPhotos()
}

// MARK: - AlbumViewModelTypeOutput

protocol AlbumViewModelTypeOutput {
  var title: String? { get }
  var photos: BehaviorRelay<[PHAsset]> { get }
}

// MARK: - AlbumViewModel

final class AlbumViewModel: AlbumViewModelTypeInput, AlbumViewModelTypeOutput {

  // MARK: Lifecycle

  init(album: PHAssetCollection) {
    self.album = album
  }

  // MARK: Internal

  var photos = BehaviorRelay<[PHAsset]>(value: [])

  var title: String? { album.localizedTitle }

  /// 사진 정보 가져오기
  func getPhotos() {
    DispatchQueue.global(qos: .userInitiated).async {
      let assets = self.album.fetchAssets
      self.photos.accept(assets)
    }
  }

  // MARK: Private

  private let disposeBag = DisposeBag()
  private let album: PHAssetCollection
}

// MARK: AlbumViewModelType

extension AlbumViewModel: AlbumViewModelType {
  var input: AlbumViewModelTypeInput { self }
  var output: AlbumViewModelTypeOutput { self }
}
