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
  let viewModel: AlbumViewModelType
  var disposeBag = DisposeBag()

  init(with viewModel: AlbumViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    viewModel.input.getPhotos()
  }
}
