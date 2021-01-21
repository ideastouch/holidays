//
//  CountriesJson.swift
//  holidaysTests
//
//  Created by GustavoHalperin on 1/17/21.
//

import Foundation

struct CountriesJson:Codable {
  struct Meta:Codable {
    let code:Int
  }
  struct Response:Codable {
    let url:String
    let countries:[Country]
  }
  let meta: Meta
  let response:Response
}
