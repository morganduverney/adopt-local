//
//  AnimalCell.swift
//  AdoptLocal
//
//  Created by Morgan Duverney on 6/2/21.
//

import UIKit

class AnimalCell: UICollectionViewCell {
    static let reuseIdentifer = String(describing: AnimalCell.self)
    
    let typeLabel = UILabel()
    let ageGenderLabel = UILabel()
    let nameLabel = UILabel()
    let descriptionLabel = UILabel()
    let separatorView = UIView()
    
    var animalsSeparator = true {
        didSet {
            updateSeparator()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AnimalCell {
    func configure() {
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        ageGenderLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        typeLabel.adjustsFontForContentSizeCategory = true
        ageGenderLabel.adjustsFontForContentSizeCategory = true
        nameLabel.adjustsFontForContentSizeCategory = true
        descriptionLabel.adjustsFontForContentSizeCategory = true
        
        nameLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0
        
        typeLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        ageGenderLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        nameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        separatorView.backgroundColor = .placeholderText
        
        contentView.addSubview(typeLabel)
        contentView.addSubview(ageGenderLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(separatorView)
        
        let views = ["type": typeLabel, "ageGender": ageGenderLabel, "name": nameLabel, "description": descriptionLabel, "separator": separatorView]
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[type]|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[name]-|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[ageGender]", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[description]-|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[separator]-|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[type]-[name]-[ageGender]-[description]-20-[separator(==1)]|",
            options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate(constraints)
    }
    func updateSeparator() {
        separatorView.isHidden = !animalsSeparator
    }
}
