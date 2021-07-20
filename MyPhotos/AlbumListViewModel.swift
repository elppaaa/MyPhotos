//
//  AlbumListViewModel.swift
//  MyPhotos
//
//  Created by JK on 2021/07/20.
//

import Foundation
import Photos
import RxSwift
import RxRelay

protocol AlbumListViewModelType {
  var input: AlbumListViewModelInput { get }
  var output: AlbumListViewModelOutput { get }
}

protocol AlbumListViewModelInput {
  func getAllAlbums()
}
protocol AlbumListViewModelOutput {
  var albums: BehaviorRelay<[Album]> { get }
}


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

extension AlbumListViewModel: AlbumListViewModelType {
  var input: AlbumListViewModelInput { self }
  var output: AlbumListViewModelOutput { self }
}
