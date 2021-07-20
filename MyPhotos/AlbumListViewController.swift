//
//  ViewController.swift
//  MyPhotos
//
//  Created by JK on 2021/07/19.
//

import UIKit
import RxSwift
import RxCocoa

final class AlbumListViewController: UIViewController {
  let disposeBag = DisposeBag()
  let viewModel: AlbumListViewModelType
  let tableView = UITableView()

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  init(with viewModel: AlbumListViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  override func loadView() {
    super.loadView()
    view.backgroundColor = .systemBackground
    view = tableView
    configTableView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configBinding()
    title = "앨범"
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    PhotoLibararyManager.requstAuthorization()
      .observe(on: MainScheduler.instance)
      .subscribe(
        onCompleted: { [weak self] in
          self?.viewModel.input.getAllAlbums()
        },
        onError: alertPhotoAccessDenied)
      .disposed(by: disposeBag)
  }
}

// MARK: - Photo Authorization
extension AlbumListViewController {
  /// 사진 접근 권한 실패 시 alert
  private func alertPhotoAccessDenied(_ err: Error) {
    let vc = UIAlertController(title: "권한 획득 실패",
                               message: "사진 접근에 실패하였습니다.\n모든 사진에 대한 권한을 허용해주세요.",
                               preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "확인", style: .default, handler: nil)
    let goSettingsAction = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
      guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
      UIApplication.shared.open(url)
    }

    vc.addAction(goSettingsAction)
    vc.addAction(OKAction)

    present(vc, animated: true, completion: nil)
  }
}

// MARK: - DataSource
extension AlbumListViewController {
  private func configBinding() {
    viewModel.output.albums
      .bind(to: tableView.rx.items(cellIdentifier: AlbumCell.identifier, cellType: AlbumCell.self)) { _, album, cell in
        cell.config(with: album)
      }
      .disposed(by: disposeBag)

    tableView.rx.itemSelected
      .withUnretained(self)
      .subscribe(onNext: { vc, indexPath in
        let album = vc.viewModel.output.albums.value[indexPath.row].assetCollection
        let viewModel = AlbumViewModel(album: album)
        vc.navigationController?.pushViewController(AlbumViewController(with: viewModel), animated: true)
      })
      .disposed(by: disposeBag)
  }
}

// MARK: - Config TableView
extension AlbumListViewController {
  private func configTableView() {
    tableView.register(AlbumCell.self, forCellReuseIdentifier: AlbumCell.identifier)
    tableView.insetsContentViewsToSafeArea = true
    tableView.rowHeight = 85.0
    tableView.tableHeaderView = UIView()
    tableView.tableFooterView = UIView()
  }
}


