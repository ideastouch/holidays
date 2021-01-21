//
//  CountriesTest.swift
//  holidaysTests
//
//  Created by GustavoHalperin on 1/17/21.
//

import XCTest
@testable import holidays
import Foundation
import Combine

class CountriesTest: XCTestCase {
  var georgia:Country {
    Country(country_name: "Georgia",
            iso_3166: "GE",
            total_holidays: 25,
            supported_languages: 4,
            uuid: "0ba64a0dea00947916dfb6a66866e1ca")
  }
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  
  func testDecode() throws {
    guard let data =  try  Data(for:type(of: self), name:"Countries")
    else {
      XCTFail("Failure converting json string file to data UTF8")
      return
    }
    let json = try JSONDecoder().decode(CountriesJson.self, from: data)
    guard let countryGe = json.response.countries.first(where: { $0.iso_3166 == "GE" }) else {
      XCTFail("Faiulure searching for Country with iso-3166 GE")
      return
    }
    XCTAssertEqual(countryGe.uuid, self.georgia.uuid)
  }
  
  func testFetch() throws {
    let expectation = XCTestExpectation(description: "countries publisher")
    let cancelable = HolidayClient().countriesPublisher()
      .sink { completion in
        switch completion {
        case .failure(let error):
          XCTFail("Failure \(error.localizedDescription)")
          expectation.fulfill()
        case .finished:
          print("Finish succesfully")
        }
      }
      receiveValue: { countries in
        guard let countryGe = countries.first(where: { $0.iso_3166 == "GE" }) else {
          XCTFail("Faiulure searching for Country with iso-3166 GE")
          return
        }
        XCTAssertEqual(countryGe.uuid, self.georgia.uuid)
        expectation.fulfill()
      }
  
    guard XCTWaiter.wait(for: [expectation], timeout: 10.0*10000) == .completed else {
      XCTFail("Fetch didn't finish on time")
      cancelable.cancel()
      return
    }
  }
  
  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
