//
//  HolidayViewController.swift
//  holidays
//
//  Created by GustavoHalperin on 1/19/21.
//

import UIKit
import Combine

class HolidayViewController: UIViewController {
  private var country:Country?
  var holidaysSubscriber:AnyCancellable?
  private var activityIndicatorView:UIActivityIndicatorView?
  private var holidayTableViewDataSource: HolidayTableViewDataSource?
  @IBOutlet weak var tableView: UITableView!
  
  func setupHolidaysSubscriber( _ country: Country,
                                publisher: AnyPublisher<[Holiday], Error>) {
    self.title = "\(country.country_name) - \(country.year)"
    self.country = country
    self.holidaysSubscriber = publisher
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { completionValue in
          if case .failure(_) = completionValue {
            print("Failure loading country \(self.country?.country_name ?? "unkonw")")
            self.dismiss(animated: true, completion: nil)
          }
        },
        receiveValue: { holidays in
          self.activityIndicatorView?.removeFromSuperview()
          self.activityIndicatorView = nil
          self.holidayTableViewDataSource?.holidays = holidays
          self.holidaysSubscriber = nil
          self.tableView.reloadData()
        })
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    self.holidayTableViewDataSource = HolidayTableViewDataSource()
    self.tableView.dataSource = self.holidayTableViewDataSource
    if self.holidaysSubscriber != nil {
      let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
      activityIndicatorView.center = self.view.center
      self.view.addSubview(activityIndicatorView)
      activityIndicatorView.startAnimating()
      self.activityIndicatorView = activityIndicatorView
    }
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
