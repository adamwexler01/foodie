//
//  DetailedViewController.swift
//  foodie_v2
//
//  Created by Adam Wexler on 5/23/19.
//  Copyright © 2019 Adam Wexler. All rights reserved.
//

import Foundation
import UIKit

class DetailedViewController: UIViewController{
    
    //Need to add ratings, review_count, price & phone_number
    
    let business: Business

    let businessImage = { ()  -> UIImageView in
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0.9
        imageView.layer.shadowRadius = 5.0
        imageView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 15.0)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .black
        return imageView
    }()
    
    let businessNameLabel = { () -> UILabel in
        let label = UILabel()
        label.font = Constants.headingStyle1
        label.textColor = Constants.textColorGray
        label.textAlignment = .center
        return label
    }()
    
    let businessAddressStackView = { () -> UIStackView in
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5.0
        stackView.alignment = UIStackView.Alignment.center
        return stackView
    }()
    
    let businessAddressIcon = { () -> UIImageView in
        let imageView = UIImageView(image: UIImage(named: "map"))
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let businessAddressLabel = { () -> UITextView in
        let label = UITextView()
        label.font = Constants.paragraphStyle1
        label.textColor = Constants.textColorGray
        label.textContainer.maximumNumberOfLines = 3
        label.textAlignment = .left
        label.isEditable = false
        label.translatesAutoresizingMaskIntoConstraints = true
        label.sizeToFit()
        label.isScrollEnabled = false
        label.dataDetectorTypes = UIDataDetectorTypes.address
        return label
    }()
    
    let businessNameStackView = { () -> UIStackView in
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5.0
        stackView.alignment = UIStackView.Alignment.center
        return stackView
    }()
    
    let dismissButton = { () -> UIButton in
        let button = UIButton()
        button.setTitle("X", for: .normal)
        button.titleLabel?.font = Constants.dismissButtonStyle
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Constants.textColorGray, for: .normal)
        button.addTarget(self, action: #selector(DetailedViewController.dismissViewController), for: .touchUpInside)
        return button
    }()
    
    let businessStackView = { () -> UIStackView in
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView;
    }()
    
    init(business: Business){
        self.business = business
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBusinessDetails()
        downloadBusinessImage()
        
        businessNameStackView.addArrangedSubview(businessNameLabel)
        businessAddressStackView.addArrangedSubview(businessAddressIcon)
        businessAddressStackView.addArrangedSubview(businessAddressLabel)
        
        businessStackView.addArrangedSubview(businessNameStackView)
        businessStackView.addArrangedSubview(businessAddressStackView)
        
        self.view.addSubview(businessStackView)
        self.view.addSubview(businessImage)
        self.view.addSubview(dismissButton)
        
        setBusinessNameStackViewConstraints()
        setBusinessAddressStackViewConstraints()
        setDismissButtonConstraints()
        setBusinessLabelConstraints()
        setBusinessImageConstraints()
        
        view.backgroundColor = UIColor.white
    }
    
    private func downloadBusinessImage() -> Void {
        
        if let url = URL(string: business.image_url) {
            getImage(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    self.businessImage.image = UIImage(data: data)
                    self.businessImage.alpha = 0.9
                    self.businessImage.layer.shadowRadius = 5.0
                    self.businessImage.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 15.0)
                }
            }
        }
    }
        
    func getImage(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    private func setBusinessNameStackViewConstraints() -> Void{
        businessNameLabel.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        businessNameStackView.distribution = .fillEqually
    }
    
    private func setBusinessAddressStackViewConstraints() -> Void{
        businessAddressIcon.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        businessAddressStackView.distribution = .fillEqually
    }
    
    private func setBusinessImageConstraints() -> Void{
        businessImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        businessImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        businessImage.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        businessImage.heightAnchor.constraint(equalToConstant: 250.0).isActive = true
    }
    
    private func setBusinessLabelConstraints() -> Void{
        businessStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        businessStackView.topAnchor.constraint(equalTo: self.businessImage.bottomAnchor, constant: 20.0).isActive = true
        businessStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        businessStackView.axis = .vertical
        businessStackView.alignment = .fill
        businessStackView.distribution = .fill
        businessStackView.spacing = 20.0
        
    }
    
    private func setDismissButtonConstraints() -> Void{
        dismissButton.centerXAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25.0).isActive = true
        dismissButton.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: 30.0).isActive = true
    }
    
    private func loadBusinessDetails() -> Void{
        businessNameLabel.text = business.name
        businessAddressLabel.text = { () -> String in
            var completeAddress = String()
            business.display_address.forEach({ (address) in
                if address != ""{
                    completeAddress += String(format: "%@\n", arguments: [address])
                }
            })
            return completeAddress
        }()
        businessAddressLabel.setNeedsDisplay()
    
    }
    
    private func isOpen() -> String{
        
        if(!business.is_closed){
            return "Open"
        } else {
            return "Closed"
        }
    }
    
    @objc func dismissViewController(){
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
