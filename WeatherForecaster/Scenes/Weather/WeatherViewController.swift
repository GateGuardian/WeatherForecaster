//
//  WeatherViewController.swift
//  WeatherForecaster
//
//  Created by Evan Kostromin on 11/10/17.
//  Copyright © 2017 ivan.kostromin.com. All rights reserved.
//

import UIKit

protocol WeatherViewModelInterface {
    
    var currentConditions: CurrentConditionViewModel? { get set }
    var weatherForecastItems: [WeatherForecastItemViewModel] { get set }
    
    var didUpdateWeatherForecast: (() -> Void)? { get set }
    var didUpdateCurrentConditions: (() -> Void)? { get set }
    
    func fetchData()
}

final class CurrentConditionViewModel {
    let conditionDescription: String?
    let temperature: String?
    let feelsLikeTemperature: String?
    let windInfo: String?
    let humidity: String?
    let date: String?
    let imageURL: URL?
    //TODO: location string
    
    init(temperature: String?, feelsLikeTemperature: String?,  humidity: String?, windInfo: String?, date: String?, conditionDescription: String?, imageURL: URL?) {
        self.temperature = temperature
        self.feelsLikeTemperature = feelsLikeTemperature
        self.humidity = humidity
        self.windInfo = windInfo
        self.date = date
        self.conditionDescription = conditionDescription
        self.imageURL = imageURL
    }
}

final class WeatherForecastItemViewModel {
    let minT: String?
    let maxT: String?
    let day: String?
    let imageURL: URL?
    let isToday: Bool
    
    init(minT: String?, maxT: String?, day: String?, imageURL: URL?, isToday: Bool) {
        self.minT = minT
        self.maxT = maxT
        self.day = day
        self.imageURL = imageURL
        self.isToday = isToday
    }
}

class WeatherViewController: UIViewController {
    var viewModel: WeatherViewModelInterface! //CAUTION! Need to provide view model as property injection
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeForViewModelEvents()
        registerCells()
        viewModel.fetchData()
    }
    
    //MARK: Private
    
    private func subscribeForViewModelEvents() {
        viewModel.didUpdateCurrentConditions = { [weak self] in
            //TODO:  the TableView header update
            self?.tableView.reloadData()
        }
        
        viewModel.didUpdateWeatherForecast = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func registerCells() {
        //TODO: cells registration
    }
}

extension WeatherViewController: UITableViewDelegate {}

extension WeatherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.weatherForecastItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
