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
  var albums: BehaviorSubject<[PHAssetCollection]> { get }
}

final class AlbumListViewModel: AlbumListViewModelInput, AlbumListViewModelOutput {
  var disposeBag = DisposeBag()
  var albums = BehaviorSubject<[PHAssetCollection]>(value: [])

  func getAllAlbums() {
    PhotoLibararyManager.fetchAllAlbums()
      .debug()
      .subscribe { [weak self] in self?.albums.onNext($0) }
      .disposed(by: disposeBag)
  }
}

extension AlbumListViewModel: AlbumListViewModelType {
  var input: AlbumListViewModelInput { self }
  var output: AlbumListViewModelOutput { self }
}
