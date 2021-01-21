//
//  CountryTableViewCell.swift
//  holidays
//
//  Created by GustavoHalperin on 1/18/21.
//

import UIKit

class CountryTableViewCell: UITableViewCell, UITextFieldDelegate {
  var country:Country? {
    didSet {
      guard let country = self.country else {
        self.yearTextField.isEnabled = false
        return
      }
      self.countryLabel.text = country.country_name
      self.yearTextField.isEnabled = true
      self.yearTextField.text = "\(country.year)"
    }
  }
  @IBOutlet weak var countryLabel: UILabel!
  @IBOutlet weak var yearTextField: UITextField!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
  // MARK: UITextFieldDelegate
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  //  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
  //    print("range: \(range), replacement: \(string)")
  //    guard NumberFormatter().number(from: string) != nil else { return false }
  //    guard let oldString = textField.text else { return false }
  //    let newString = oldString.replacingCharacters(in: Range(range, in: oldString)!,
  //                                                  with: string)
  //    print("new value \(newString)")
  //    guard let year = NumberFormatter().number(from: newString),
  //          year.intValue < 2100
  //          else { return false }
  //
  //    return true
  //  }
  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let country = self.country else { return }
    guard let text = textField.text else {
      self.yearTextField.text = "\(country.year)"
      return }
    guard let year = NumberFormatter().number(from: text) else {
      self.yearTextField.text = "\(country.year)"
      return
    }
    HolidaysManager.shared.updateCountry(name: country.country_name, year: year.intValue)
  }
}
