//
//  CountriesViewController.swift
//  holidays
//
//  Created by GustavoHalperin on 1/17/21.
//

import UIKit
import Combine

class CountriesViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate {
  @IBOutlet weak var countrySearchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  private var countriesSubscriber: AnyCancellable?
  private var countriesDataSource: CountriesTableViewDataSource?
  private var activityIndicatorView: UIActivityIndicatorView?
  
  private func updateCountries(countries:[Country]? = nil) {
    let countries = countries ??  HolidaysManager.shared.getCountries()
    let filtered = countries.filter { country -> Bool in
      guard let searchValue = self.searchValue else { return true }
      return country.country_name.lowercased().contains(searchValue.lowercased())
    }
    self.countriesDataSource?.countries = filtered
    self.tableView.reloadData()
  }
  override func viewDidLoad() {
    let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    activityIndicatorView.center = self.view.center
    self.view.addSubview(activityIndicatorView)
    activityIndicatorView.startAnimating()
    self.activityIndicatorView = activityIndicatorView
    self.countriesSubscriber = HolidaysManager.shared
      .countryPublisher
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { completionValue in
          if case .failure(_) = completionValue {
            print("Failure, stop spinning or what ever was started")
            self.activityIndicatorView?.removeFromSuperview()
            self.activityIndicatorView = nil
          }
        },
        receiveValue: { value in
          self.countriesDataSource = CountriesTableViewDataSource(countries: [Country]())
          self.tableView.dataSource = self.countriesDataSource
          self.updateCountries(countries: value)
          self.activityIndicatorView?.removeFromSuperview()
          self.activityIndicatorView = nil
        })
  }
  
  // MARK: UISearchBarDelegate
  @Published
  private var searchValue: String?
  private var searchValueSubscriber: AnyCancellable?
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    self.searchValue = searchBar.text?.count ?? 0 > 0 ? searchBar.text : nil
    self.searchValueSubscriber = self.$searchValue
      .debounce(for:.seconds(0.5), scheduler: RunLoop.main)
      .sink(receiveValue: { _ in
        self.updateCountries()
      })
  }
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    self.searchValue = searchText.count > 0 ? searchText : nil
  }
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    if segue.identifier == "CountriesToHolidaysSegue" {
//      guard let holidayViewController = segue.destination as? HolidayViewController else {
//        return
//      }
////      let selected = self.tableView.selected
//      holidayViewController.holidays =
//    }
//  }
  // MARK: UITableViewDelegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let holidayViewController = UIStoryboard(name: "Main", bundle:nil)
            .instantiateViewController(withIdentifier: "HolidayViewControllerId") as? HolidayViewController else {
      print("Failure loading HolidayViewControllerId")
      return
    }
    guard let country = self.countriesDataSource?.countries[indexPath.row] else {
      print("Failure finding selected country at row \(indexPath.row)")
      return
    }
    let holidaysPublisher = HolidayClient().holidays(country:country.iso_3166, year:country.year)
    holidayViewController.setupHolidaysSubscriber( country, publisher: holidaysPublisher) 
    self.navigationController?.pushViewController(holidayViewController, animated: true)
  }
}
