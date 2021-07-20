//
//  AlbumViewModel.swift
//  MyPhotos
//
//  Created by JK on 2021/07/20.
//

import Foundation
import UIKit.UIImage
import Photos
import RxRelay
import RxSwift

protocol AlbumViewModelType {
  var input: AlbumViewModelTypeInput { get }
  var output: AlbumViewModelTypeOutput { get }
}

protocol AlbumViewModelTypeInput {
  func getPhotos()
}

protocol AlbumViewModelTypeOutput {
  var title: String? { get }
  var photos: BehaviorRelay<[PHAsset]> { get }
}

final class AlbumViewModel: AlbumViewModelTypeInput, AlbumViewModelTypeOutput {
  var disposeBag = DisposeBag()
  init(album: PHAssetCollection) {
    self.album = album
  }
  
  private let album: PHAssetCollection
  var title: String? { album.localizedTitle }
  var photos = BehaviorRelay<[PHAsset]>(value: [])
  
  /// 사진 정보 가져오기
  func getPhotos() {
    DispatchQueue.global(qos: .userInitiated).async {
      let assets = self.album.fetchAssets
      self.photos.accept(assets)
    }
  }
}

extension AlbumViewModel: AlbumViewModelType {
  var input: AlbumViewModelTypeInput { self }
  var output: AlbumViewModelTypeOutput { self }
}
