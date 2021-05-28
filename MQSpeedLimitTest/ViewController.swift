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
    
    @IBOutlet weak var stopNavButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        let totalScale = ((mainImage.bounds.width / 326) + (mainImage.bounds.height / 407)) / 2
        
        SLLLeading.constant = 70 * (mainImage.bounds.width / 326)
        SLLTrailing.constant = 70 * (mainImage.bounds.width / 326)
        SLLBottom.constant = 235 * (mainImage.bounds.height / 407)
        SLLHeight.constant = 182 * (mainImage.bounds.height / 407)
        
        speedLimitLabel.font = speedLimitLabel.font.withSize(190 * totalScale)
    }
    
    func navigationManager(_ navigationManager: MQNavigationManager, crossedSpeedLimitBoundariesWithExitedZones exitedSpeedLimits: Set<MQSpeedLimit>?, enteredZones enteredSpeedLimits: Set<MQSpeedLimit>?) {
       // update UI to reflect new speed limits.
        print("NEW SPEED LIMIT: \(enteredSpeedLimits!)")
        print("EXITED SPEED LIMIT: \(exitedSpeedLimits!)")
        
//        guard let updateSpeedLimit = delegate?.update(speedLimit:) else { return }
        
        if enteredSpeedLimits?.count == 0 {
            speedLimitLabel.text = "?"
        }
        
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

    @IBAction func stopNavigation(_ sender: Any) {
        var titleToSet: String = ""
        switch navigationManager.navigationManagerState {
        case .navigating:
            navigationManager.cancelNavigation()
            titleToSet = "Start Navigation"
            speedLimitLabel.text = "?"
        case .paused:
            navigationManager.resumeNavigation()
            titleToSet = "Stop Navigation"
        case .stopped:
            startRoute()
            titleToSet = "Stop Navigation"
        default:
            navigationManager.cancelNavigation()
            titleToSet = "Start Navigation"
            speedLimitLabel.text = "?"
        }
        
        stopNavButton.setTitle("   \(titleToSet)   ", for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("willDisappear")
    }
    
    fileprivate lazy var navigationManager: MQNavigationManager! = {
        let manager = MQNavigationManager(delegate: self, promptDelegate: self)
        manager?.userLocationTrackingConsentStatus = .denied; // Production code requires this be set by providing the user with a Terms of Service dialog.
        return manager
    }()
    fileprivate lazy var routeService = MQRouteService()

    //set up start and destination for the route

    fileprivate let fakeDestination = CLLocation(latitude: 48.377354, longitude: -124.622832)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        startRoute()
        
        NotificationCenter.default.addObserver(self, selector: #selector(EndNavigation(_:)), name: NSNotification.Name(rawValue: "EndNavigation"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BeginNavigation(_:)), name: NSNotification.Name(rawValue: "BeginNavigation"), object: nil)
    }

    @objc func EndNavigation(_ notification: Notification) {
        print("Received!!")
        navigationManager.cancelNavigation()
        speedLimitLabel.text = "?"
        stopNavButton.setTitle("   Start Navigation   ", for: .normal)
    }
    
    @objc func BeginNavigation(_ notification: Notification) {
        print("Received!!")
        startRoute()
//        speedLimitLabel.text = "?"
        stopNavButton.setTitle("   Stop Navigation   ", for: .normal)
    }
    
    func startRoute() {
        let options = MQRouteOptions()
        options.highways = .allow
        options.tolls = .allow
        options.ferries = .avoid
        options.unpaved = .avoid
        options.internationalBorders = .disallow
        options.seasonalClosures = .avoid
        options.maxRoutes = 1
        options.systemOfMeasurementForDisplayText = .imperial
        options.language = "en_US"
        
//        let userLocation :CLLocation = locations[0] as CLLocation
        let currentLat = locationManager.location?.coordinate.latitude ?? 40
        let currentLong = locationManager.location?.coordinate.longitude ?? 70
        let currentLocation = CLLocation(latitude: currentLat, longitude: currentLong)
        
        //request route
        routeService.requestRoutes(withStart: currentLocation, destinationLocations:[fakeDestination], options: options) { [weak self] (routes, error) in
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

