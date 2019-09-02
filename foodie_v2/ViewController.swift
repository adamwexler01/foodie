//
//  ViewController.swift
//  foodie_v2
//
//  Created by Adam Wexler on 5/20/19.
//  Copyright © 2019 Adam Wexler. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    let filterView = FilterView()
    let mainView = UIView()
    var timer = Timer()
    let locationManager = CLLocationManager()
    var currentLocation = CLLocationCoordinate2D()
    
    let errorLabel = { () -> UILabel in
        let label = UILabel()
        label.font = Constants.paragraphStyle1
        label.textColor = Constants.errorStyle
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = ""
        return label
    }()
    
    let feedMeButton = { () -> UIButton in
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 35.0
        button.setTitle("Feed me", for: .normal)
        button.setTitleColor(Constants.textColorGray, for: .normal)
        button.titleLabel?.font = UIFont(name: "GillSans-Light", size: 30.0)
        button.layer.borderColor = Constants.textColorGray.cgColor
        button.layer.borderWidth = 3.0
        button.contentEdgeInsets = UIEdgeInsets(top: 22.5, left: 40.0, bottom: 22.5, right: 40.0)
        button.addTarget(self, action: #selector(ViewController.didPressFeedMeButton), for: .touchUpInside)
        return button
    }()
    
    let stackView = { () -> UIStackView in
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView;
    }()
    
    let spinnerView = { () -> SpinnerView in
        let spinnerView = SpinnerView()
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        return spinnerView
    }()
    
    let filterButton = { () -> UIButton in
        let button = UIButton()
        button.setImage(UIImage(named: "Filter"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = .white
        button.contentEdgeInsets = UIEdgeInsets(top: 15.0, left: -27.0, bottom: 15.0, right:   -27.0)
        button.layer.cornerRadius = 30.0
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(displayP3Red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
        button.addTarget(self, action: #selector(presentSettingsView), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        
        filterView.frame = CGRect(x: 0.0, y: self.view.frame.height - 200.0, width: self.view.frame.width, height: 200.0)
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "restaurant")?.draw(in: self.view.bounds)

        if let image = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.mainView.backgroundColor = UIColor(patternImage: image).withAlphaComponent(0.4)
        }else{
            UIGraphicsEndImageContext()
            debugPrint("Image not available")
        }
        
        stackView.addArrangedSubview(feedMeButton)
        mainView.addSubview(stackView)
        mainView.addSubview(filterButton)
        self.view.addSubview(mainView)
        setStackViewConstraints()
        setFilterButtonConstaints()
    }
    
    @objc func didPressFeedMeButton(_ sender: UIButton){
        toggleNetworkIndicator(value: true)
        feedMeButton.setTitle("            ", for: .normal)
        feedMeButton.addSubview(spinnerView)
        setSpinnerViewConstraints()
        getBusiness()
    }
    
    private func getBusiness(){
        guard let url = URL(string: "https://foodie-app-api.herokuapp.com/") else { return }
        
        var request = URLRequest(url: url)
        if(currentLocation.latitude.rounded().isEqual(to: 38.0)){
            request.setValue("\(32.7939039)", forHTTPHeaderField: "latitude")
        } else {
            request.setValue("\(currentLocation.latitude)", forHTTPHeaderField: "latitude")
        }
        
        if(currentLocation.longitude.rounded().isEqual(to: -122.0)){
            request.setValue("\(-96.7997089)", forHTTPHeaderField: "longitude")
        } else {
            request.setValue("\(currentLocation.longitude)", forHTTPHeaderField: "longitude")
        }
        
        if(filterView.distanceLabel.text == "Radius"){
            request.setValue("5.0", forHTTPHeaderField: "radius")
        } else {
            request.setValue(filterView.distanceLabel.text, forHTTPHeaderField: "radius")
        }
        
        var categories = String()
        
        filterView.selectedPreferences.forEach { (selection) in
            categories += "\(selection.lowercased()),"
        }
        
        request.setValue(String(categories.dropLast()), forHTTPHeaderField: "categories")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if (error == nil){
                do{
                    
                    let business = try JSONDecoder().decode(Business.self, from: data!)
                    
                    DispatchQueue.main.async {
                        self.removeSpinnerView()
                        self.presentDetailViewController(business: business)
                    }
                    
                } catch let errorMessage as NSError{
                    self.addExceptionMessage(error: errorMessage)
                }
            } else {
                DispatchQueue.main.async {
                    self.addExceptionMessage(error: nil)
                }
            }
        }
        
        task.resume()
    }
    
    private func addExceptionMessage(error: NSError?){
        self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.removeErrorLabel), userInfo: nil, repeats: false)
        self.errorLabel.text = "Request Failed. Try again!"
        self.stackView.addArrangedSubview(self.errorLabel)
        self.removeSpinnerView()
    }
    
    @objc func removeErrorLabel(_ sender: UILabel){
        errorLabel.removeFromSuperview()
        timer.invalidate()
        self.viewDidLoad()
    }
    
    @objc func presentSettingsView(_ sender: UIButton){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.mainView.frame = CGRect(x: 0.0, y: -200.0, width: self.mainView.frame.width, height: self.mainView.frame.height)
            self.view.insertSubview(self.filterView, belowSubview: self.mainView)
        }) { (true) in
            self.restoresFocusAfterTransition = true
            self.feedMeButton.isUserInteractionEnabled = false
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissSettingsView))
            self.filterButton.removeGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.presentSettingsView(_:))))
            self.filterButton.addGestureRecognizer(gesture)
            self.mainView.addGestureRecognizer(gesture)
        }
    }
    
    @objc func dismissSettingsView(_ sender: UIButton){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.mainView.frame = CGRect(x: 0.0, y: 0.0, width: self.mainView.frame.width, height: self.mainView.frame.height)
            self.filterView.removeFromSuperview()
        }) { (true) in
            self.restoresFocusAfterTransition = true
            self.feedMeButton.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissSettingsView))
            self.filterButton.removeGestureRecognizer(gesture)
            self.mainView.removeGestureRecognizer(gesture)
            self.filterButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.presentSettingsView(_:))))
        }
    }
    
    private func removeSpinnerView() -> Void{
        feedMeButton.willRemoveSubview(self.spinnerView)
        spinnerView.removeFromSuperview()
        feedMeButton.setTitle("Feed me", for: .normal)
    }
    
    private func presentDetailViewController(business: Business){
        toggleNetworkIndicator(value: false)
        let detailedViewController = DetailedViewController(business: business)
        detailedViewController.modalPresentationStyle = .overCurrentContext
        self.present(detailedViewController, animated: true, completion: nil)
    }
    
    private func setStackViewConstraints(){
        stackView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8.0
    }
    
    private func setSpinnerViewConstraints(){
        spinnerView.centerXAnchor.constraint(equalTo: feedMeButton.centerXAnchor).isActive = true
        spinnerView.centerYAnchor.constraint(equalTo: feedMeButton.centerYAnchor).isActive = true
        spinnerView.heightAnchor.constraint(equalTo: feedMeButton.heightAnchor, constant: -49.0).isActive = true
        spinnerView.widthAnchor.constraint(equalTo: feedMeButton.widthAnchor, constant: -150.0).isActive = true
    }
    
    private func setFilterButtonConstaints(){
        filterButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -25.0).isActive = true
        filterButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -25.0).isActive = true
        filterButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        currentLocation = locationValue
    }
    
    private func toggleNetworkIndicator(value: Bool){
        UIApplication.shared.isNetworkActivityIndicatorVisible = value
    }

}

