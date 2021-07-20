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
  var albums: BehaviorSubject<[Album]> { get }
}


final class AlbumListViewModel: AlbumListViewModelInput, AlbumListViewModelOutput {
  var disposeBag = DisposeBag()
  var albums = BehaviorSubject<[Album]>(value: [])

  func getAllAlbums() {
    DispatchQueue.global(qos: .background).async {
      let fetchedResult = PhotoLibararyManager.fetchAllAlbums()
      let albums = fetchedResult.map { collection -> Album in
        let assets = collection.fetchAssets
        return Album(title: collection.localizedTitle, recentPhoto: assets.first, count: assets.count)
      }

      self.albums.onNext(albums)
    }
  }
}

extension AlbumListViewModel: AlbumListViewModelType {
  var input: AlbumListViewModelInput { self }
  var output: AlbumListViewModelOutput { self }
}
