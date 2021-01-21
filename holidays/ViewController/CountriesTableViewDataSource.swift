//
//  CountriesTableDataSource.swift
//  holidays
//
//  Created by GustavoHalperin on 1/18/21.
//

import UIKit
import Combine

class CountriesTableViewDataSource: NSObject ,UITableViewDataSource {
  var countries: [Country]
  init(countries:[Country]) {
    self.countries = countries
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return countries.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCellId", for: indexPath)
    guard let countryTableViewCell = cell as? CountryTableViewCell else {
      return cell
    }
    countryTableViewCell.country = countries[indexPath.row]
    return countryTableViewCell
  }
}
