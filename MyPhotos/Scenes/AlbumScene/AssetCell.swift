//
//  AssetCell.swift
//  MyPhotos
//
//  Created by JK on 2021/07/20.
//

import Photos.PHAsset
import RxSwift
import UIKit

// MARK: - AssetCell

final class AssetCell: UICollectionViewCell {

  // MARK: Lifecycle

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  override init(frame: CGRect) {
    super.init(frame: frame)
    configLayout()
    configAccessibility()
  }

  // MARK: Internal

  override var reuseIdentifier: String? { Self.identifier }

  override func prepareForReuse() {
    super.prepareForReuse()
    disposable?.dispose()
    disposable = nil
  }

  // MARK: Private

  private var disposable: Disposable?

  private lazy var imageView = UIImageView(frame: bounds).then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }

  private func configLayout() {
    imageView.translatesAutoresizingMaskIntoConstraints = false

    contentView.addSubview(imageView)
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
    ])
  }
}

// MARK: - Config Cell
extension AssetCell {
  func config(with asset: PHAsset) {
    disposable = asset.rx.image(size: imageView.bounds.size)
      .asDriver(onErrorJustReturn: nil)
      .drive(imageView.rx.image)
  }
}

// MARK: - Accessibility
extension AssetCell {
  private func configAccessibility() {
    isAccessibilityElement = true
    accessibilityLabel = "Image".localized
    accessibilityHint = "Tap to view photo information".localized
    accessibilityTraits = .image
  }
}
