//
//  Countries.swift
//  holidays
//
//  Created by GustavoHalperin on 1/17/21.
//

import Foundation
import Combine

class Countries: ObservableObject {
  @Published
  var countries = [Country]()
}
