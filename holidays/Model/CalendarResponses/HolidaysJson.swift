//
//  HolidaysJson.swift
//  holidaysTests
//
//  Created by GustavoHalperin on 1/17/21.
//

import Foundation

struct HolidaysJson: Decodable {
  struct Meta: Codable {
    let code: Int
  }
  struct Response: Codable {
    let holidays: [Holiday]
  }
  let meta:Meta
  let response: Response
}
