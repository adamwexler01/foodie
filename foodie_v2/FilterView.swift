//
//  FilterView.swift
//  foodie_v2
//
//  Created by Adam Wexler on 8/30/19.
//  Copyright © 2019 Adam Wexler. All rights reserved.
//

import Foundation
import UIKit

class FilterView: UIView{
    
    let preferenceList = ["Any", "Italian", "Mexican", "Asian", "American"]
    var selectedPreferences:[String] = []
    
    let stackView = { () -> UIStackView in
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let distanceStackView = { () -> UIStackView in
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 15.0
        return stackView
    }()
    
    let preferencesStackView = { () -> UIStackView in
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 10.0
        return stackView
    }()
    
    let distanceLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "Radius"
        label.font = Constants.headingStyle1
        label.textColor = Constants.textColorGray
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let distanceInput = { () -> UIStepper in
        let stepper = UIStepper()
        stepper.stepValue = 1.0
        stepper.maximumValue = 25.0
        stepper.isContinuous = true
        stepper.tintColor = Constants.textColorGray
        stepper.addTarget(self, action: #selector(updateDistanceLabel), for: .valueChanged)
        return stepper
    }()
    
    let preferencesLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "Preferences"
        label.font = Constants.headingStyle1
        label.textColor = Constants.textColorGray
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let preferencesCollectionView = { () -> UICollectionView in
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CustomFilterCell.self, forCellWithReuseIdentifier: "cell")
//        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        preferencesCollectionView.delegate = self
        preferencesCollectionView.dataSource = self
        
        distanceStackView.addArrangedSubview(distanceLabel)
        distanceStackView.addArrangedSubview(distanceInput)
        preferencesStackView.addArrangedSubview(preferencesLabel)
        preferencesStackView.addArrangedSubview(preferencesCollectionView)
        stackView.addArrangedSubview(distanceStackView)
        stackView.addArrangedSubview(preferencesStackView)
        self.addSubview(stackView)
        configStackView()
        preferencesCollectionView.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
        preferencesCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10.0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func hello(){
        print("Hello")
    }
    
    private func configStackView(){
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally //.fillEqually
        stackView.spacing = 25.0
    }
    
    @objc func updateDistanceLabel(){
        distanceLabel.text = "\(distanceInput.value) mi"
    }
    
}

extension FilterView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.3, height: collectionView.frame.height / 3.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return preferenceList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomFilterCell
        print(preferenceList[indexPath.item])
        cell.data = self.preferenceList[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! CustomFilterCell
        if(!selectedPreferences.contains(cell.data!)){
            selectedPreferences.append(cell.data ?? "")
            cell.label.backgroundColor = UIColor(displayP3Red: 150.0/255.0, green: 150.0/255.0, blue: 150.0/255.0, alpha: 0.3)
            cell.label.textColor = .darkText
        } else {
            selectedPreferences.removeAll { (value) -> Bool in
                if(value == cell.data){
                    cell.label.backgroundColor = .white
                    cell.label.textColor = Constants.textColorGray
                    return true
                }
                return false
            }
        }
        
        print(selectedPreferences)
    }
    
}

class CustomFilterCell: UICollectionViewCell {
    
    var data: String? {
        didSet {
            guard let data = data else { return }
            label.text = data
        }
    }
    
    let label = { () -> UILabel in
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.textColorGray
        label.adjustsFontSizeToFitWidth = true
        label.layer.borderColor = Constants.textColorGray.cgColor
        label.layer.borderWidth = 1.0
        label.layer.cornerRadius = 10.0
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.font = Constants.paragraphStyle1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        updateLabelConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateLabelConstraints(){
        label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
}
