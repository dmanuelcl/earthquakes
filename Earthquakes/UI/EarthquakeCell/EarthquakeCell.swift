//
//  EarthquakeCell.swift
//  Earthquakes
//
//  Created by Dani Manuel Céspedes Lara on 8/31/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import UIKit
import AppDomain

class EarthquakeCell: UITableViewCell{
    @IBOutlet weak var magnitudeIndicator: UIView!
    @IBOutlet weak var magnitudeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    func configure(with model: Earthquake){
      
    }
    
    override func prepareForReuse() {
        self.magnitudeIndicator.backgroundColor = UIColor.gray
        self.magnitudeLabel.text = "-"
        self.magnitudeLabel.textColor = self.magnitudeIndicator.backgroundColor
    }
}
