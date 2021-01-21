//
//  Country.swift
//  holidays
//
//  Created by GustavoHalperin on 1/17/21.
//

import Foundation

extension Int {
  static var currentYear: Int {
    Calendar.current.component(.year, from: Date())
  }
}

struct Country: Codable {
  let country_name:String
  let iso_3166:String // iso-3166
  let total_holidays:Int
  let supported_languages:Int
  let uuid:String
  var year = Int.currentYear
  enum CodingKeys: String, CodingKey {
    case country_name
    case iso_3166 = "iso-3166"
    case total_holidays
    case supported_languages
    case uuid
  }
}
extension Country: Equatable { }
