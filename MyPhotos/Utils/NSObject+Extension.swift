//
//  NSObject+Extension.swift
//  MyPhotos
//
//  Created by JK on 2021/07/20.
//

import Foundation

extension NSObject {
  static var identifier: String { String(describing: Self.self) }
}
