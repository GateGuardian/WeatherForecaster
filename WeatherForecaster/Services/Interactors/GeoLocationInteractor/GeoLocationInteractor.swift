//
//  GeoLocationInteractor.swift
//  WeatherForecaster
//
//  Created by Evan Kostromin on 11/10/17.
//  Copyright © 2017 ivan.kostromin.com. All rights reserved.
//

import Foundation
import CoreLocation

protocol GeoLocationInteractorInterface: class {
    func refreshCurrentGeoLocation()
    func fetchCurrentGeoLocation()
    func cancelFetching()
}

protocol GeoLocationInteractorDelegate: class {
    func didFetchCurrentGeoLocation(_ location: GeoLocation)
    func didFailToFetchGeoLocation(withError: Error)
}

class GeoLocationInteractor: NSObject, GeoLocationInteractorInterface {
    
    weak var delegate: GeoLocationInteractorDelegate?
    private let geoLocationGateway: GeoLocationGateway
    private let coreLocationManager: CLLocationManager
    private var cancelationToken: CancellationToken?
    private var afterAuthorizationAction: (() -> Void)?
    
    private var lastGeoLocation: GeoLocation?
    
    //MARK: Lifecycle
    
    init(geoLocationGateway: GeoLocationGateway, coreLocationManager: CLLocationManager) {
        self.geoLocationGateway = geoLocationGateway
        self.coreLocationManager = coreLocationManager
        super.init()
        self.coreLocationManager.delegate = self
    }
    
    //MARK: GeoLocationInteractorInterface
    
    func refreshCurrentGeoLocation() {
        lastGeoLocation = nil
        fetchCurrentGeoLocation()
    }
    
    func fetchCurrentGeoLocation() {
        //1. Check for cached GeoLocation / CLLocation
        if let lastLocation = lastGeoLocation {
            self.delegate?.didFetchCurrentGeoLocation(lastLocation)
            return
        }
        //2. Check CoreLocationManager Auth status
        if !coreLocationManager.isAuthorized {
            coreLocationManager.requestWhenInUseAuthorization()
            afterAuthorizationAction = { [weak self] in
                self?.coreLocationManager.requestLocation()
            }
            return
        }
        //3  Get CLLocation
        coreLocationManager.requestLocation()
    }
    
    func cancelFetching() {
        cancelationToken?.cancel()
    }
}

extension GeoLocationInteractor: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if manager.isAuthorized {
            afterAuthorizationAction?()
            afterAuthorizationAction = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            //TODO: send error
            return
        }
        cancelationToken = geoLocationGateway.geoLocation(withLocation: location) { [weak self] (response) in
            guard let strongSelf = self else { return }
            switch response {
                case .failure(let error): strongSelf.delegate?.didFailToFetchGeoLocation(withError: error)
                case .success(let data):
                    strongSelf.lastGeoLocation = data
                    strongSelf.delegate?.didFetchCurrentGeoLocation(data)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFailToFetchGeoLocation(withError: CoreLocationError(withError: error))
    }
}

extension CLLocationManager {
    var isAuthorized: Bool {
        get {
            return CLLocationManager.authorizationStatus() != .denied && CLLocationManager.authorizationStatus() != .notDetermined
        }
    }
}

enum CoreLocationError: Error {
    case errorLocationUnknown
    case errorDenied
    case errorNetwork
    case errorUnknown
    
    init(withError: Error) {
        switch (withError as NSError).code  {
            case 0: self = .errorLocationUnknown
            case 1: self = .errorDenied
            case 2: self = .errorNetwork
            default: self = .errorUnknown
        }
    }
}
