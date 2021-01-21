//
//  HolidayTableViewDataSource.swift
//  holidays
//
//  Created by GustavoHalperin on 1/20/21.
//

import UIKit

class HolidayTableViewDataSource: NSObject, UITableViewDataSource {
  var holidays: [Holiday]? {
    didSet {
      self.holidaysSorted = self.holidays?.sorted { $0.date.iso < $1.date.iso }
    }
  }
  private var holidaysSorted: [Holiday]?
  var holidayPresented: [Holiday]?  { self.holidaysSorted }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    self.holidaysSorted?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "HolidayTableViewCellId", for: indexPath)
    guard let holidayTableViewCell = cell as? HolidayTableViewCell else { return cell }
    holidayTableViewCell.holiday = self.holidaysSorted?[indexPath.row]
    return holidayTableViewCell
  }
}
