//
//  ViewController.swift
//  MyPhotos
//
//  Created by JK on 2021/07/19.
//

import UIKit
import Photos
import RxSwift

final class AlbumListViewController: UITableViewController {
  var allPhotos: PHFetchResult<PHAsset>?
  let disposeBag = DisposeBag()

  override func loadView() {
    super.loadView()
    view.backgroundColor = .systemBackground
    configTableView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    PhotoLibararyManager.requstAuthorization()
      .observe(on: MainScheduler.instance)
      // tableView reload when complte
      .subscribe(onCompleted: {  },
                 onError: alertPhotoAccessDenied)
      .disposed(by: disposeBag)
  }
}

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

extension AlbumListViewController {
  private func configTableView() {
    tableView.register(AlbumCell.self, forCellReuseIdentifier: AlbumCell.identifier)
    tableView.rowHeight = 85.0
  }
}
