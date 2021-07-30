//
//  String+Extension.swift
//  MyPhotos
//
//  Created by JK on 2021/07/30.
//

import Foundation

extension String {
  public var localized: String {
    NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")
  }
}
