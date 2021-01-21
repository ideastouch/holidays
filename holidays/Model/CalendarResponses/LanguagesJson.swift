//
//  LanguagesJson.swift
//  holidaysTests
//
//  Created by GustavoHalperin on 1/17/21.
//

import Foundation

struct LanguagesJson:Codable {
  struct Meta:Codable {
    let code:Int
  }
  struct Response:Codable {
    let url:String
    let languages:[Language]
  }
  let meta: Meta
  let response:Response
}
