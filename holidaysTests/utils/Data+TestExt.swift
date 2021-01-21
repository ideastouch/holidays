//
//  Data+TestExt.swift
//  holidaysTests
//
//  Created by GustavoHalperin on 1/17/21.
//

import Foundation

extension Data {
  init?(for aClass: AnyClass, name:String) throws {
    guard let path = Bundle(for: aClass).path(forResource: name, ofType: "json")
    else {
      throw "\(name).json file wasn't found"
    }
    let url = URL(fileURLWithPath: path)
    let string = try String(contentsOf: url, encoding: .utf8)
    guard let data = string.data(using: .utf8) else { return nil }
    self = data
  }
}
