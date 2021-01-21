//
//  HolidayClient.swift
//  holidays
//
//  Created by GustavoHalperin on 1/17/21.
//

import Foundation
import Combine

extension String {
  func addKey<T>(key:String, value:T) -> String{
    return self + "&\(key)=\(value)"
  }
  func addApiKey(_ value:String) -> String{
    return self + "?api_key=\(value)"
  }
}
class HolidayClient {
  private let apiKey = "ff20d580de6a08f05fbde03519be354a78bcd5e9"
  private let webApi = "https://calendarific.com/api/v2/"
  private var countryCancelable: AnyCancellable?
  private func apiPath(_ root:String) -> String {
    (self.webApi + root).addApiKey(self.apiKey)
  }
  private var countriesPath: String { self.apiPath("countries") }
  private var languagesPath: String { self.apiPath("languages") }
  private var holidaysPath: String { self.apiPath("holidays") }
  
  
  private func fetchDataPublisher(_ url:URL) -> AnyPublisher<Data,Error> {
    URLSession.shared.dataTaskPublisher(for: url)
      .tryMap({ (arg0) -> (data: Data, httpUesponse: HTTPURLResponse) in
        guard let httpResponse = arg0.1 as? HTTPURLResponse else { throw "URL Response bad format" }
        return (arg0.0, httpResponse)
      })
      .tryMap({ (arg0) -> Data in
        guard arg0.1.statusCode == 200 else { throw "Bad response status code: \(arg0.1)" }
        return arg0.data
      })
      .eraseToAnyPublisher()
  }
  func countriesPublisher() -> AnyPublisher< [Country],Error> {
    guard let url = URL(string: self.countriesPath) else {
      return Fail<[Country],Error>(error:"Failure creating countries URL").eraseToAnyPublisher()
    }
    return self.fetchDataPublisher(url)
      .decode(type: CountriesJson.self, decoder: JSONDecoder())
      .tryMap({ (json) -> [Country] in
        guard json.meta.code == 200 else { throw "Bad response status code on data: \(json.meta.code)" }
        return json.response.countries
      })
      .eraseToAnyPublisher()
  }
  
  func languagesPublisher() -> AnyPublisher< [Language],Error> {
    guard let url = URL(string: self.languagesPath) else {
      return Fail<[Language],Error>(error:"Failure creating languages URL").eraseToAnyPublisher()
    }
    return self.fetchDataPublisher(url)
      .decode(type: LanguagesJson.self, decoder: JSONDecoder())
      .tryMap({ (json) -> [Language] in
        guard json.meta.code == 200 else { throw "Bad response status code on data: \(json.meta.code)" }
        return json.response.languages
      })
      .eraseToAnyPublisher()
  }
  func holidays(country:String, year:Int) -> AnyPublisher< [Holiday], Error > {
    let holidaysPath = self.holidaysPath
      .addKey(key: "country", value: country)
      .addKey(key: "year", value: year)
    
    guard let url = URL(string: holidaysPath) else {
      return Fail<[Holiday],Error>(error:"Failure creating Holidays URL").eraseToAnyPublisher()
    }
    return self.fetchDataPublisher(url)
      .decode(type: HolidaysJson.self, decoder: JSONDecoder())
      .tryMap({ (json) -> [Holiday] in
        guard json.meta.code == 200 else { throw "Bad response status code on data: \(json.meta.code)" }
        return json.response.holidays
      })
      .eraseToAnyPublisher()
  }
}
