//
//  ForeCastTableViewCell.swift
//  KSCAssignment
//
//  Created by Preeyapol Owatsuwan on 25/3/2566 BE.
//

import Foundation
import UIKit

class ForeCastTableViewCell: UITableViewCell {
    @IBOutlet private weak var foreCastView: UIView!
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var iconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dayLabel.text = ""
        dateLabel.text = ""
        temperatureLabel.text = ""
        iconImage.image = nil
    }
    
    private func configureView() {
        foreCastView.setRadiusCorners(radius: 24)
    }
    
    func updateCell(with model: ForeCastCellModel) {
        dayLabel.text = model.day
        dateLabel.text = model.date
        timeLabel.text = model.time
        temperatureLabel.text = model.tempCelcius
        
        if let url = model.iconURL {
            iconImage.downloadImage(from: url)
        } else {
            iconImage.image = UIImage(named: "all-weather-icon")
        }
    }
}
