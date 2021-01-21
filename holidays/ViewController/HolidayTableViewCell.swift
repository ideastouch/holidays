//
//  HolidayTableViewCell.swift
//  holidays
//
//  Created by GustavoHalperin on 1/20/21.
//

import UIKit

class HolidayTableViewCell: UITableViewCell {
  var holiday:Holiday? {
    didSet {
      self.nameLabel.text = self.holiday?.name
      let month = self.holiday?.date.datetime.month ?? 0
      let day = self.holiday?.date.datetime.day ?? 0
      self.dateLabel.text = "\(month) - \(day)"
      self.descriptionTextView.text = self.holiday?.description
    }
  }
  
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var descriptionTextView: UITextView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}

