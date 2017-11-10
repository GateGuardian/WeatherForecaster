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
    var didUpdateCityName: ((_ cityName: String ) -> Void)? { get set }
    var didFinishLoading: (() -> Void)? { get set }
    
    func fetchData()
    func refreshData()
}

final class CurrentConditionViewModel {
    let conditionDescription: String?
    let temperature: String?
    let feelsLikeTemperature: String?
    let windInfo: String?
    let humidity: String?
    let pressure: String?
    let date: String?
    let imageURL: URL?
    
    init(temperature: String?, feelsLikeTemperature: String?,  humidity: String?, pressure: String?, windInfo: String?, date: String?, conditionDescription: String?, imageURL: URL?) {
        self.temperature = temperature
        self.feelsLikeTemperature = feelsLikeTemperature
        self.humidity = humidity
        self.pressure = pressure
        self.windInfo = windInfo
        self.date = date
        self.conditionDescription = conditionDescription
        self.imageURL = imageURL
    }
}

final class WeatherForecastItemViewModel {
    
    let temperatureString: String?
    let day: String?
    let imageURL: URL?
    
    init(temperatureString: String?, day: String?, imageURL: URL?) {
        self.temperatureString = temperatureString
        self.day = day
        self.imageURL = imageURL
    }
}

class WeatherViewController: UIViewController {
    var viewModel: WeatherViewModelInterface! //CAUTION! Need to provide view model as property injection
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerView: CurrentConditionsView!
    @IBOutlet private weak var cityLabel: UILabel!
    private let refreshControll = UIRefreshControl()
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeForViewModelEvents()
        setupRefresh()
        registerCells()
        viewModel.fetchData()
    }
    
    //MARK: Private
    
    private func subscribeForViewModelEvents() {
        viewModel.didUpdateCityName = {[weak self] cityName in
            self?.cityLabel.text = cityName
        }
        viewModel.didUpdateCurrentConditions = { [weak self] in
            self?.configureHeaderView()
        }
        viewModel.didUpdateWeatherForecast = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.didFinishLoading = { [weak self] in
            self?.refreshControll.endRefreshing()
        }
    }
    
    private func registerCells() {
        let nib = UINib(nibName: ForecastDayTableViewCell.reuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ForecastDayTableViewCell.reuseIdentifier)
    }
    
    private func setupRefresh() {
        refreshControll.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControll.tintColor = UIColor.white
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControll
        } else {
            tableView.backgroundView = refreshControll
        }
    }
    
    @objc private func refreshData() {
        viewModel.refreshData()
    }
    
    private func configure(cell: ForecastDayTableViewCell, with item: WeatherForecastItemViewModel) {
        cell.dayString = item.day
        cell.tempString = item.temperatureString
        cell.imageUrl = item.imageURL
    }
    
    private func configureHeaderView() {
        guard let currentConditions = viewModel.currentConditions else { return }
        headerView.descriptionString = currentConditions.conditionDescription
        headerView.temperatureString = currentConditions.temperature
        headerView.feelsLikeString = currentConditions.feelsLikeTemperature
        headerView.humidityString = currentConditions.humidity
        headerView.pressureString = currentConditions.pressure
        headerView.windString = currentConditions.windInfo
        headerView.imageUrl = currentConditions.imageURL
    }
}

extension WeatherViewController: UITableViewDelegate {}

extension WeatherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.weatherForecastItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastDayTableViewCell.reuseIdentifier) as! ForecastDayTableViewCell
        configure(cell: cell, with: viewModel.weatherForecastItems[indexPath.row])
        return cell
    }
}
