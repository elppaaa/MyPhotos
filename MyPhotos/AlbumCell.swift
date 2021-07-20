//
//  AlbumCell.swift
//  MyPhotos
//
//  Created by JK on 2021/07/20.
//

import UIKit

final class AlbumCell: UITableViewCell {
  override var reuseIdentifier: String? { Self.identifier }
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  init() {
    super.init(style: .default, reuseIdentifier: Self.identifier)

    configLayout()
  }

  private(set) lazy var thumbnail = UIImageView()
  private(set) lazy var title = UILabel()
  private(set) lazy var photosCount = UILabel()
}

extension AlbumCell {
  private func configLayout() { }
}
