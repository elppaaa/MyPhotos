//
//  AlbumCell.swift
//  MyPhotos
//
//  Created by JK on 2021/07/20.
//

import UIKit
import Then

final class AlbumCell: UITableViewCell {
  override var reuseIdentifier: String? { Self.identifier }
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  override init(style: UITableViewCell.CellStyle, reuseIdentifier _: String?) {
    super.init(style: .default, reuseIdentifier: Self.identifier)
    configLayout()
  }

  private lazy var thumbnail = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 70.0, height: 70.0)) .then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }

  private lazy var title = UILabel().then {
    $0.font = .systemFont(ofSize: 17.0)
    $0.textColor = .black
  }

  private lazy var photosCount = UILabel().then {
    $0.font = .systemFont(ofSize: 12.0)
    $0.textColor = .black
  }

  private func configLayout() {
    selectionStyle = .none
    accessoryType = .disclosureIndicator

    let stack = UIStackView(arrangedSubviews: [title, photosCount])
    thumbnail.translatesAutoresizingMaskIntoConstraints = false
    stack.translatesAutoresizingMaskIntoConstraints = false

    contentView.addSubview(thumbnail)
    stack.alignment = .leading
    stack.axis = .vertical
    stack.spacing = 10.0
    stack.distribution = .fillEqually
    contentView.addSubview(stack)

    NSLayoutConstraint.activate([
      thumbnail.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      thumbnail.heightAnchor.constraint(equalToConstant: 70.0),
      thumbnail.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
      thumbnail.widthAnchor.constraint(equalToConstant: 70.0),

      stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      stack.heightAnchor.constraint(equalToConstant: 45.0),
      stack.leadingAnchor.constraint(equalTo: thumbnail.trailingAnchor, constant: 15.0),
      stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
    ])
  }


}

// MARK: - Config Cell 
extension AlbumCell {
  func config(with album: Album) {
    guard let size = imageView?.bounds.size else { return }
    thumbnail.image = album.recentPhoto?.image(size: size)
    title.text = album.title
    photosCount.text = String(album.count)
  }
}
