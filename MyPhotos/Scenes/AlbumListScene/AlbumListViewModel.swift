//
//  AlbumListViewModel.swift
//  MyPhotos
//
//  Created by JK on 2021/07/20.
//

import Foundation
import Photos
import RxRelay
import RxSwift

// MARK: - AlbumListViewModelType

protocol AlbumListViewModelType {
  var input: AlbumListViewModelInput { get }
  var output: AlbumListViewModelOutput { get }
}

// MARK: - AlbumListViewModelInput

protocol AlbumListViewModelInput {
  func getAllAlbums()
}

// MARK: - AlbumListViewModelOutput

protocol AlbumListViewModelOutput {
  var albums: BehaviorRelay<[Album]> { get }
}

// MARK: - AlbumListViewModel

final class AlbumListViewModel: AlbumListViewModelInput, AlbumListViewModelOutput {
  var disposeBag = DisposeBag()
  var albums = BehaviorRelay<[Album]>(value: [])

  func getAllAlbums() {
    DispatchQueue.global(qos: .userInitiated).async {
      let fetchedResult = PhotoLibararyManager.fetchAllAlbums()
      let albums = fetchedResult.map { collection -> Album in
        let assets = collection.fetchAssets
        return Album(
          title: collection.localizedTitle,
          recentPhoto: assets.first,
          count: assets.count,
          assetCollection: collection)
      }

      self.albums.accept(albums)
    }
  }
}

// MARK: AlbumListViewModelType

extension AlbumListViewModel: AlbumListViewModelType {
  var input: AlbumListViewModelInput { self }
  var output: AlbumListViewModelOutput { self }
}
