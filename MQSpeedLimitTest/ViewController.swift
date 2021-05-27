//
//  ViewController.swift
//  MQSpeedLimitTest
//
//  Created by Dylan McDonald on 5/27/21.
//

import UIKit
import MQNavigation
import CoreLocation

class ViewController: UIViewController, MQNavigationManagerDelegate, MQNavigationManagerPromptDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    func navigationManager(_ navigationManager: MQNavigationManager, receivedPrompt promptToSpeak: MQPrompt, userInitiated: Bool) {
        print("receivedPrompt: promptToSpeak")
    }
    
    func cancelPrompts(for navigationManager: MQNavigationManager) {
        print("cancelPrompts")
    }
    
    
    func navigationManager(_ navigationManager: MQNavigationManager, failedToStartNavigationWithError error: Error) {
        print("failedToStartNavigationWithError \(error)")
    }
    

    @IBOutlet weak var mainImage: UIImageView!
    
    @IBOutlet weak var speedLimitLabel: UILabel!
    @IBOutlet weak var SLLTrailing: NSLayoutConstraint!
    @IBOutlet weak var SLLLeading: NSLayoutConstraint!
    @IBOutlet weak var SLLBottom: NSLayoutConstraint!
    @IBOutlet weak var SLLHeight: NSLayoutConstraint!
    
    override func viewDidAppear(_ animated: Bool) {
        let totalScale = ((mainImage.bounds.width / 326) + (mainImage.bounds.height / 407)) / 2
        
        SLLLeading.constant = 70 * (mainImage.bounds.width / 326)
        SLLTrailing.constant = 70 * (mainImage.bounds.width / 326)
        SLLBottom.constant = 235 * (mainImage.bounds.height / 407)
        SLLHeight.constant = 182 * (mainImage.bounds.height / 407)
        
        speedLimitLabel.font = speedLimitLabel.font.withSize(190 * totalScale)
    }
    
    func navigationManager(_ navigationManager: MQNavigationManager, crossedSpeedLimitBoundariesWithExitedZones exitedSpeedLimits: Set<MQSpeedLimit>?, enteredZones enteredSpeedLimits: Set<MQSpeedLimit>?) {
       // update UI to reflect new speeed limits.
        print("NEW SPEED LIMIT: \(enteredSpeedLimits!)")
        
//        guard let updateSpeedLimit = delegate?.update(speedLimit:) else { return }
        
        guard let enteredSpeedLimits = enteredSpeedLimits, enteredSpeedLimits.count > 0 else {
            return
        }
        
        for limit in enteredSpeedLimits {
            if limit.speedLimitType == .maximum {
                speedLimitLabel.text = String(Int(limit.speed * 2.237))
                return
            }
        }
    }

    fileprivate lazy var navigationManager: MQNavigationManager! = {
        let manager = MQNavigationManager(delegate: self, promptDelegate: self)
        manager?.userLocationTrackingConsentStatus = .denied; // Production code requires this be set by providing the user with a Terms of Service dialog.
        return manager
    }()
    fileprivate lazy var routeService = MQRouteService()

    //set up start and destination for the route
    fileprivate let nyc = CLLocation(latitude:40.7326808, longitude:-73.9843407)
    fileprivate let boston = CLLocation(latitude:42.355097, longitude:-71.055464)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        let options = MQRouteOptions()
        options.highways = .allow
        options.tolls = .avoid
        options.ferries = .avoid
        options.unpaved = .avoid
        options.internationalBorders = .disallow
        options.seasonalClosures = .avoid
        options.maxRoutes = 3
        options.systemOfMeasurementForDisplayText = .imperial
        options.language = "en_US"
        
//        let userLocation :CLLocation = locations[0] as CLLocation
//
//           print("user latitude = \(userLocation.coordinate.latitude)")
//           print("user longitude = \(userLocation.coordinate.longitude)")
        
        //request route
        routeService.requestRoutes(withStart: nyc, destinationLocations:[boston], options: options) { [weak self] (routes, error) in
            guard let strongSelf = self else { return }

            //handle error
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                strongSelf.present(alert, animated: true, completion: nil)
                return
            }
            guard let routes = routes, routes.isEmpty == false else { return }

            //start navigation with first route
            strongSelf.navigationManager.startNavigation(with: routes[0])
            
        }
    }

}

