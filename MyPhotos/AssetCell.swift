//
//  AssetCell.swift
//  MyPhotos
//
//  Created by JK on 2021/07/20.
//

import UIKit

final class AssetCell: UICollectionViewCell {
  override var reuseIdentifier: String? { Self.identifier }
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  override init(frame: CGRect) {
    super.init(frame: frame)
    configLayout()
  }

  private lazy var imageView = UIImageView().then {
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

  func set(image: UIImage?) {
    imageView.image = image
  }
}
