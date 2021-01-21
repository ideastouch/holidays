//
//  LanguagesClientTest.swift
//  holidaysTests
//
//  Created by GustavoHalperin on 1/17/21.
//

import XCTest
@testable import holidays
import Foundation

class LanguagesTest: XCTestCase {
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testDecode() throws {
    guard let data =  try  Data(for:type(of: self), name:"Languages")
    else {
      XCTFail("Failure converting json string file to data UTF8")
      return
    }
    let json = try JSONDecoder().decode(LanguagesJson.self, from: data)
    
    guard let languageRW = json.response.languages.first(where: { $0.code == "rw" }) else {
      XCTFail("Faiulure searching for Language with code rw")
      return
    }
    let kinyarwanda = Language(code:"rw",name:"Kinyarwanda",nativeName:"Ikinyarwanda")
    XCTAssertEqual(languageRW, kinyarwanda)
  }
  
  func testFetch() throws {
    let expectation = XCTestExpectation(description: "languages publisher")
    let cancelable = HolidayClient().languagesPublisher()
      .sink { completion in
        switch completion {
        case .failure(let error):
          XCTFail("Failure \(error.localizedDescription)")
          expectation.fulfill()
        case .finished:
          print("Finish succesfully")
        }
      }
      receiveValue: { languages in
        guard let languageRW = languages.first(where: { $0.code == "rw" }) else {
          XCTFail("Faiulure searching for Language with code rw")
          return
        }
        let kinyarwanda = Language(code:"rw",name:"Kinyarwanda",nativeName:"Ikinyarwanda")
        XCTAssertEqual(languageRW, kinyarwanda)
        expectation.fulfill()
      }
  
    guard XCTWaiter.wait(for: [expectation], timeout: 10.0) == .completed else {
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
