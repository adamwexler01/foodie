//
//  SettingViewController.swift
//  foodie_v2
//
//  Created by Adam Wexler on 5/26/19.
//  Copyright © 2019 Adam Wexler. All rights reserved.
//

import Foundation
import UIKit

class SettingViewController:UIViewController{
    
    let settingStackView = { () -> UIStackView in
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10.0
        return stackView
    }()
    
    let settingHeader = { () -> UILabel in
        let label = UILabel()
        label.font = UIFont(name: "TrebuchetMS-Bold", size: 25.0)
        label.textColor = Constants.textColorGray
        label.text = "Settings"
        label.textAlignment = .center
        return label
    }()
    
    let distanceStackView = { () -> UIStackView in
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    let distanceHeading = { () -> UILabel in
        let label = UILabel()
        label.font = Constants.paragraphStyle1
        label.textColor = Constants.textColorGray
        label.text = "Distance"
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    let distanceSlider = { () -> UISlider in
        let slider = UISlider()
        slider.value = 0.0
        slider.minimumValue = 0.0
        slider.maximumValue = 25.0
        slider.thumbTintColor = Constants.sliderColor
        slider.minimumTrackTintColor = Constants.sliderBarColor
        slider.addTarget(self, action: #selector(updateDistanceLabel), for: .touchDragInside)
        return slider
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
        
        distanceStackView.addArrangedSubview(distanceHeading)
        distanceStackView.addArrangedSubview(distanceSlider)
        settingStackView.addArrangedSubview(settingHeader)
        settingStackView.addArrangedSubview(distanceStackView)
        self.view.addSubview(settingStackView)
        
        setSettingStackViewConstraints()
    }
    
    private func setSettingStackViewConstraints(){
        settingStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        settingStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20.0).isActive = true
        settingStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50.0).isActive = true
        settingStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50.0).isActive = true
    }
    
    @objc func updateDistanceLabel(_ sender: UISlider){
        distanceHeading.text = "\(sender.value.rounded())"
    }
    
}

