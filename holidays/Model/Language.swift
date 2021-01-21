//
//  Language.swift
//  holidays
//
//  Created by GustavoHalperin on 1/17/21.
//

import Foundation

struct Language: Codable {
  let code:String
  let name:String
  let nativeName:String
}
extension Language: Equatable {}
