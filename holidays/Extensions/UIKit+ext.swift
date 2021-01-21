//
//  UIKit+ext.swift
//  holidays
//
//  Created by GustavoHalperin on 1/19/21.
//

import UIKit

extension UIView {
  var cornerRadius: CGFloat {
    get { self.layer.cornerRadius }
    set { self.layer.cornerRadius = newValue }
  }
}
