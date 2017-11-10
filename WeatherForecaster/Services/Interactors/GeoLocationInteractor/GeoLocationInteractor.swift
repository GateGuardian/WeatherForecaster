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
        let coreGatewayError = CoreGatewayError.networkError(detailedError(fromCLError: error))
        delegate?.didFailToFetchGeoLocation(withError: coreGatewayError)
    }
}

extension CLLocationManager {
    var isAuthorized: Bool {
        get {
            return CLLocationManager.authorizationStatus() != .denied && CLLocationManager.authorizationStatus() != .notDetermined
        }
    }
}

extension GeoLocationInteractor {
    
    enum LocationManagerErrorDescription {
        static let errorLocationUnknown = "Location is currently unknown, but CL will keep trying"
        static let errorDenied = "Access to location or ranging has been denied by the user"
        static let errorNetwork = "Some network-related error"
        static let errorUnknown = "Some location error"
    }
    
    func detailedError(fromCLError: Error) -> Error {
        switch (fromCLError as NSError).code {
        case 0:
            return NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : LocationManagerErrorDescription.errorLocationUnknown])
        case 1:
            return NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : LocationManagerErrorDescription.errorDenied])
        case 2:
            return NSError(domain: "", code: 2, userInfo: [NSLocalizedDescriptionKey : LocationManagerErrorDescription.errorNetwork])
        default:
            return NSError(domain: "", code: 3, userInfo: [NSLocalizedDescriptionKey : LocationManagerErrorDescription.errorUnknown])
        }
    }
}
