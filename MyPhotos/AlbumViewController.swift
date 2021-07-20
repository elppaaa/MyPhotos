//
//  AlbumViewController.swift
//  MyPhotos
//
//  Created by JK on 2021/07/20.
//

import UIKit
import RxSwift

final class AlbumViewController: UIViewController {
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  init(with viewModel: AlbumViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  var disposeBag = DisposeBag()
  let viewModel: AlbumViewModelType
  private var preferredItemSize: CGSize = .zero
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

  /// 파일 정보 표시
  private func alertAssetInfo(title: String, size: Float) {
    let message = "파일명: \(title)\n파일크기: \(round(size))MB"
    let alert = UIAlertController(title: "사진정보", message: message, preferredStyle: .alert)

    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(OKAction)

    present(alert, animated: true, completion: nil)
  }
}

// MARK: - Binding
extension AlbumViewController {
  private func configBinding() {
    viewModel.output.photos
      .bind(to: collectionView.rx.items(cellIdentifier: AssetCell.identifier, cellType: AssetCell.self)) { _, asset, cell in
        cell.set(image: asset.image(size: self.preferredItemSize))
      }
      .disposed(by: disposeBag)


    collectionView.rx.itemSelected
      .debug()
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

    layout.itemSize = self.preferredItemSize

    return layout
  }
}

