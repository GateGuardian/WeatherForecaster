//
//  CurrentConditionsView.swift
//  WeatherForecaster
//
//  Created by Evan Kostromin on 11/10/17.
//  Copyright © 2017 ivan.kostromin.com. All rights reserved.
//

import UIKit
import Kingfisher

class CurrentConditionsView: UIView {
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var windLabel: UILabel!
    @IBOutlet private weak var feelsLikeLabel: UILabel!
    @IBOutlet private weak var pressureLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    
    
    var temperatureString: String? {
        get { return temperatureLabel.text }
        set { temperatureLabel.text = newValue }
    }
    
    var descriptionString: String? {
        get { return descriptionLabel.text }
        set { descriptionLabel.text = newValue }
    }

    var humidityString: String? {
        get { return humidityLabel.text }
        set { humidityLabel.text = newValue }
    }
    
    var windString: String? {
        get { return windLabel.text }
        set { windLabel.text = newValue }
    }
    
    var feelsLikeString: String? {
        get { return feelsLikeLabel.text }
        set { feelsLikeLabel.text = newValue }
    }
    
    var pressureString: String? {
        get { return pressureLabel.text }
        set { pressureLabel.text = newValue }
    }
    
    var imageUrl: URL? {
        didSet {
            guard let url = imageUrl else { return }
            let imageResource = ImageResource(downloadURL: url)
            imageView.kf.setImage(with: imageResource)
        }
    }
}
