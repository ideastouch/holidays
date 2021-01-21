//
//  HolidaysTest.swift
//  holidaysTests
//
//  Created by GustavoHalperin on 1/17/21.
//

import XCTest
@testable import holidays
import Foundation
import Combine

class HolidaysTest: XCTestCase {
  var nationalCleanUpDay: Holiday {
    Holiday(name: "National CleanUp Day",
            description: "National CleanUp Day is a observance in the USA",
            country: Holiday.Country(id: "us", name: "United States"),
            date: Holiday.Date(iso: "2019-09-21",
                               datetime: Holiday.Date.Datetime(year: 2019,
                                                               month: 9,
                                                               day: 21)),
            type: ["Observance"],
            locations: "All")
  }
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
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
    XCTAssertEqual(holidayNCD, self.nationalCleanUpDay)
  }
  func testFetch() throws {
    let expectations = XCTestExpectation(description: "fetch holidays")
    let cancelable = HolidayClient().holidays(country: "US", year: 2019)
      .sink {  comletion in
        switch comletion {
        case .failure(let error):
          XCTFail("fetch error \(error.localizedDescription)")
          expectations.fulfill()
        case .finished:
          print("fetch completion ended")
        }
      }
      receiveValue: { holidays in//([Holiday]) in
        guard let holidayNCD = holidays.first(where: { $0.name == "National CleanUp Day" }) else {
          XCTFail(#"Faiulure searching for holiday "National CleanUp Day""#)
          return
        }
        XCTAssertEqual(holidayNCD, self.nationalCleanUpDay)
        expectations.fulfill()
      }
    if XCTWaiter.wait(for: [expectations], timeout: 10.0) != .completed {
      XCTFail("Fetch ended without completion")
      cancelable.cancel()
    }
  }
  
  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
