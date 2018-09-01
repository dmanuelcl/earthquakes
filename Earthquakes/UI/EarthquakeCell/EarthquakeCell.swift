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
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var magnitudeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let dateFormatter = DateFormatter()
    
    func configure(with model: Earthquake){
        self.dateFormatter.dateFormat = "MMMM dd, yyyy, hh:mm:ss a"
        self.placeLabel.text = model.place
        self.magnitudeIndicator.backgroundColor = model.magnitudeColor
        self.containerView.backgroundColor = model.magnitudeColor.withAlphaComponent(0.20)
        if let magnitude = model.magnitude{
            self.magnitudeLabel.text = String(magnitude.magnitude)
        }else{
            self.magnitudeLabel.text = "-"
        }
        self.dateLabel.text = self.dateFormatter.string(from: model.time)
    }
    
    override func prepareForReuse() {
        self.magnitudeIndicator.backgroundColor = UIColor.gray
        self.magnitudeLabel.text = "-"
    }
}
