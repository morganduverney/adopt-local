//
//  AnimalCell.swift
//  AdoptLocal
//
//  Created by Morgan Duverney on 6/2/21.
//

import UIKit

class AnimalCell: UICollectionViewCell {
    static let reuseIdentifer = String(describing: AnimalCell.self)
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderAgeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

}
