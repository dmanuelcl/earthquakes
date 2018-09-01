//
//  LoadingView.swift
//  Earthquakes
//
//  Created by Dani Manuel Céspedes Lara on 9/1/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import UIKit


/// A very very simple loading view
class LoadingView{
    private let activityIndicator: UIActivityIndicatorView
    private let overlayView: UIView
    
    init() {
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        self.activityIndicator.tintColor = UIColor.white
        self.activityIndicator.sizeToFit()
        
        self.overlayView = UIView(frame: UIScreen.main.bounds)
        self.overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
    }
    
    
    /// Display the loading view animated
    func display(){
        self.overlayView.alpha = 0
        UIApplication.shared.keyWindow?.addSubview(self.overlayView)
        self.overlayView.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        self.activityIndicator.center = self.overlayView.center
        UIView.animate(withDuration: 0.3) {
            self.overlayView.alpha = 1
        }
    }
    

    /// Hide the loading view animated
    func hide(){
        UIView.animate(withDuration: 0.3, animations: {
             self.overlayView.alpha = 0
        }) { _ in
            self.overlayView.removeFromSuperview()
            self.activityIndicator.removeFromSuperview()
            self.activityIndicator.stopAnimating()
        }
    }
}
