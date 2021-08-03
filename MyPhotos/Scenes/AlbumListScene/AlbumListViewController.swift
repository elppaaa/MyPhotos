//
//  ViewController.swift
//  MyPhotos
//
//  Created by JK on 2021/07/19.
//

import RxCocoa
import RxSwift
import UIKit

// MARK: - AlbumListViewController

final class AlbumListViewController: UIViewController {

  // MARK: Lifecycle

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  init(with viewModel: AlbumListViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  // MARK: Internal

  override func loadView() {
    super.loadView()
    view.backgroundColor = .systemBackground
    view = tableView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configBinding()
    title = "Albums".localized
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    // 사진 접근 권한 확인
    PhotoLibararyManager.requstAuthorization()
      .observe(on: MainScheduler.instance)
      .subscribe(
        onCompleted: viewModel.input.getAllAlbums,
        onError: alertPhotoAccessDenied)
      .disposed(by: disposeBag)
  }

  // MARK: Private

  private let disposeBag = DisposeBag()
  private let viewModel: AlbumListViewModelType
  private let tableView = UITableView().then {
    $0.register(AlbumCell.self, forCellReuseIdentifier: AlbumCell.identifier)
    $0.insetsContentViewsToSafeArea = true
    $0.rowHeight = 85.0
    $0.tableHeaderView = UIView()
    $0.tableFooterView = UIView()
  }

}

// MARK: - Photo Authorization
extension AlbumListViewController {
  /// 사진 접근 권한 실패 시 alert
  private func alertPhotoAccessDenied(_ err: Error) {
    let vc = UIAlertController(
      title: "Failed to access Photos".localized,
      message: "Please check `All Photos` in the settings.".localized,
      preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "Confirm".localized, style: .default, handler: nil)
    let goSettingsAction = UIAlertAction(title: "Go to settings".localized, style: .default) { _ in
      guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
      UIApplication.shared.open(url)
    }

    vc.addAction(goSettingsAction)
    vc.addAction(OKAction)

    present(vc, animated: true, completion: nil)
  }
}

// MARK: - DataSource & Delgate
extension AlbumListViewController {
  private func configBinding() {
    /// cellForRowAt
    /// `viewModel.output.albums`를 관찰하여 `tableView` 업데이트
    viewModel.output.albums
      .bind(to: tableView.rx.items(cellIdentifier: AlbumCell.identifier, cellType: AlbumCell.self)) { _, album, cell in
        cell.config(with: album)
      }
      .disposed(by: disposeBag)

    /// didSelectRowAt
    /// `tableView` 내부 셀 선택시 호출.
    /// 셀 선택시 해당 앨범의 사진목록 표시
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
