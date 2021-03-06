//
//  AlbumCell.swift
//  MyPhotos
//
//  Created by JK on 2021/07/20.
//

import RxSwift
import Then
import UIKit

// MARK: - AlbumCell

final class AlbumCell: UITableViewCell {

  // MARK: Lifecycle

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  override init(style: UITableViewCell.CellStyle, reuseIdentifier _: String?) {
    super.init(style: .default, reuseIdentifier: Self.identifier)
    configLayout()
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

  private lazy var thumbnail = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 70.0, height: 70.0)) .then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }

  private lazy var title = UILabel().then {
    $0.font = .preferredFont(forTextStyle: .body)
    $0.textColor = .label
  }

  private lazy var photosCount = UILabel().then {
    $0.font = .preferredFont(forTextStyle: .caption1)
    $0.textColor = .label
  }

  private func configLayout() {
    selectionStyle = .none
    accessoryType = .disclosureIndicator

    let stack = UIStackView(arrangedSubviews: [title, photosCount])
    thumbnail.translatesAutoresizingMaskIntoConstraints = false
    stack.translatesAutoresizingMaskIntoConstraints = false

    stack.alignment = .leading
    stack.axis = .vertical
    stack.spacing = 10.0
    stack.distribution = .fillEqually

    contentView.addSubview(thumbnail)
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
    title.text = album.title
    photosCount.text = String(album.count)
    disposable = album.recentPhoto?.rx.image(size: thumbnail.bounds.size)
      .asDriver(onErrorJustReturn: nil)
      .drive(thumbnail.rx.image)
  }
}
