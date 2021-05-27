
//
//  AboutTableViewController.swift
//  School Assistant
//
//  Created by Dylan McDonald on 6/14/20.
//  Copyright © 2020 Dylan McDonald. All rights reserved.
//

import UIKit
import CoreLocation
import SafariServices


class AboutTableViewController: UITableViewController, SFSafariViewControllerDelegate {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 4 {
            let urlString = "https://sunapps.org"
            if let url = URL(string: urlString) {
                let vc = SFSafariViewController(url: url)
                vc.preferredControlTintColor = UIColor(named: "AccentColor")
                vc.view.tintColor = UIColor(named: "AccentColor")
                vc.delegate = self
                present(vc, animated: true)
            }
        }
        
        if indexPath.section == 7 {
            
            let urlString = "https://sunapps.org/privacypolicy"
            if let url = URL(string: urlString) {
                let vc = SFSafariViewController(url: url)
                vc.preferredControlTintColor = UIColor(named: "AccentColor")
                vc.view.tintColor = UIColor(named: "AccentColor")
                vc.delegate = self
                present(vc, animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

class ButtonCell: UITableViewCell {
    override func draw(_ rect: CGRect) {

        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.label.withAlphaComponent(0.075).cgColor
        
        self.textLabel?.textColor = UIColor(named: "AccentColor")
        self.accessoryView?.tintColor = UIColor(named: "AccentColor")

    }
}


func areLocationServicesEnabled() -> String {
    var toReturn: String = "Denied"
    let locationManager = CLLocationManager()

    if CLLocationManager.locationServicesEnabled() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
                toReturn = "Please choose While Using the App when prompted for Location Services."
            
        case .restricted, .denied:
            toReturn = "Denied. Please go to Settings → Privacy → Location Services → Keep Left and choose While Using the App."
            case .authorizedAlways, .authorizedWhenInUse:
                toReturn = "Enabled"
            @unknown default:
            break
        }
        } else {
            toReturn = "Denied. Please go to Settings → Privacy → Location Services → Keep Left and choose While Using the App."
    }
    
    if toReturn == "Enabled" {
        if locationManager.accuracyAuthorization == .reducedAccuracy {
            toReturn = "Not fully allowed. Please go to Settings → Privacy → Location Services → Keep Left and turn on Precise Location."
        }
    }
    
    return toReturn
}


// Note: if your iPhone becomes overheated (which may happen if you use your iPhone in your dashboard), your iPhone will automatically lower the max brightness.
