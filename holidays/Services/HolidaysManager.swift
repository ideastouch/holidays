//
//  HolidaysManager.swift
//  holidays
//
//  Created by GustavoHalperin on 1/18/21.
//

import Foundation
import Combine


final class HolidaysManager {
  static let shared = HolidaysManager()
  
  private var countriesSubscriber: AnyCancellable?
  @Published
  private var countries = [Country]()
  var countryPublisher: Published<[Country]>.Publisher { self.$countries }
  func getCountries() -> [Country] { return self.countries }
  
  
  private init() {
    self.countriesSubscriber = HolidayClient()
      .countriesPublisher()
      .sink(
        receiveCompletion: { completionValue in
          switch completionValue {
          case .failure(let error):
            print("Error \(error.localizedDescription)")
          case .finished:
            print("Completion without Error")
          }
        },
        receiveValue: { countries in
          self.countries = countries
      })
    
  }
  
  func updateCountry(name:String, year:Int) {
    guard let index = self.countries.firstIndex(where: { $0.country_name == name } )else { return }
    guard year > 1900, year < 2100 else {
      self.countries[index].year = Int.currentYear
      return
    }
    self.countries[index].year = year
  }
  
}
