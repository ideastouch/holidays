//
//  Holiday.swift
//  holidays
//
//  Created by GustavoHalperin on 1/17/21.
//

import Foundation

struct Holiday: Codable, Equatable {
  struct Country: Codable, Equatable {
    let id:String
    let name:String
  }
  struct Date: Codable, Equatable {
    struct Datetime: Codable, Equatable {
      let year:Int
      let month:Int
      let day:Int
    }
    let iso:String
    let datetime: Datetime
  }
  let name:String
  let description:String
  let country:Country
  let date:Date
  let type: [String]
  let locations:String
}

/**

func testDecode() throws {
  guard let data =  try  Data(for:type(of: self), name:"HolidaysUS2019")
  else {
    XCTFail("Failure converting json string file to data UTF8")
    return
  }
  let json = try JSONDecoder().decode(HolidaysJson.self, from: data)
  guard let holidayNCD = json.response.holidays.first(where: { $0.name == "National CleanUp Day" }) else {
    XCTFail(#"Faiulure searching for holiday "National CleanUp Day""#)
    return
  }
  let nationalCleanUpDay = Holiday(name: "National CleanUp Day",
                                   description: "National CleanUp Day is a observance in the USA",
                                   country: Holiday.Country(id: "us", name: "United States"),
                                   date: Holiday.Date(iso: "2019-09-21",
                                                      datetime: Holiday.Date.Datetime(year: 2019,
                                                                                      month: 9,
                                                                                      day: 21)),
                                   type: ["Observance"],
                                   locations: "All")
  XCTAssertEqual(holidayNCD, nationalCleanUpDay)
}

 */
