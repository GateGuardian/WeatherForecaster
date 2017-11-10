//
//  ForecastDayTableViewCell.swift
//  WeatherForecaster
//
//  Created by Evan Kostromin on 11/10/17.
//  Copyright © 2017 ivan.kostromin.com. All rights reserved.
//

import UIKit
import Kingfisher

class ForecastDayTableViewCell: UITableViewCell {
    
    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var dayLabel: UILabel!
    @IBOutlet private var tempLabel: UILabel!
    
    static let reuseIdentifier = String(describing: ForecastDayTableViewCell.self)
    
    var tempString: String? {
        get { return tempLabel.text }
        set { tempLabel.text = newValue }
    }
    
    var dayString: String? {
        get { return dayLabel.text }
        set { dayLabel.text = newValue}
    }
    
    var imageUrl: URL? {
        didSet {
            guard let url = imageUrl else { return }
            let imageResource = ImageResource(downloadURL: url)
            iconImageView.kf.setImage(with: imageResource)
        }
    }
}

