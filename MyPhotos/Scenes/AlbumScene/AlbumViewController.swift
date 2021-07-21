//
//  AlbumViewController.swift
//  MyPhotos
//
//  Created by JK on 2021/07/20.
//

import RxSwift
import UIKit

// MARK: - AlbumViewController

final class AlbumViewController: UIViewController {

  // MARK: Lifecycle

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  init(with viewModel: AlbumViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  // MARK: Internal

  private let disposeBag = DisposeBag()
  private let viewModel: AlbumViewModelType
  lazy var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout()).then {
    $0.alwaysBounceVertical = true
    $0.register(AssetCell.self, forCellWithReuseIdentifier: AssetCell.identifier)
  }

  override func loadView() {
    super.loadView()
    view = collectionView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = viewModel.output.title
    view.backgroundColor = .systemBackground

    configBinding()
    viewModel.input.getPhotos()
  }

  // MARK: Private

  private var preferredItemSize: CGSize = .zero

  /// 파일 정보 표시
  private func alertAssetInfo(title: String, size: Float) {
    let message = "파일명: \(title)\n파일크기: \(round(size * 10) / 10)MB"
    let alert = UIAlertController(title: "사진정보", message: message, preferredStyle: .alert)

    let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
    alert.addAction(confirmAction)

    present(alert, animated: true, completion: nil)
  }
}

// MARK: - Binding
extension AlbumViewController {
  private func configBinding() {
    // cellForRowAt
    viewModel.output.photos
      .bind(to: collectionView.rx.items(
              cellIdentifier: AssetCell.identifier, cellType: AssetCell.self)) { _, asset, cell in
          cell.config(with: asset)
      }
      .disposed(by: disposeBag)

    // didSelectItemAt
    collectionView.rx.itemSelected
      .observe(on: MainScheduler.instance)
      .withUnretained(self)
      .subscribe(onNext: { vc, indexPath in
        let asset = self.viewModel.output.photos.value[indexPath.row]
        guard let name = asset.fileName, let size = asset.fileSize else { return }
        vc.alertAssetInfo(title: name, size: size)
      })
      .disposed(by: disposeBag)
  }
}

// MARK: - Create Layout
extension AlbumViewController {
  private func createLayout() -> UICollectionViewFlowLayout {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 4.0
    layout.minimumInteritemSpacing = 4.0

    let screenWidth = view.bounds.size.width
    let preferredWidth = (screenWidth - 4.0 * 2) / 3
    preferredItemSize = .init(width: preferredWidth, height: preferredWidth)

    layout.itemSize = preferredItemSize

    return layout
  }
}
