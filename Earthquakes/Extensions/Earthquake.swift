//
//  Earthquake.swift
//  Earthquakes
//
//  Created by Dani Manuel Céspedes Lara on 8/31/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import UIKit
import AppDomain
import AVFoundation

extension Earthquake{
    
    /// Return an UIColor based on eqrthquake magnitude
    var magnitudeColor: UIColor{
        guard let magnitude = self.magnitude else {
            return UIColor.gray
        }
        switch magnitude {
        case .low:
            return UIColor.green
        case .moderate:
            return UIColor.yellow
        case .high:
            return UIColor.orange
        case .extreme:
            return UIColor.red
        }
    }
    
    
    /// Return an UIImage based on eqrthquake magnitude
    var magnitudeImage: UIImage{
        guard let magnitude = self.magnitude else {
            return #imageLiteral(resourceName: "map_pin_gray")
        }
        switch magnitude {
        case .low:
            return #imageLiteral(resourceName: "map_pin_green")
        case .moderate:
            return #imageLiteral(resourceName: "map_pin_yellow")
        case .high:
            return #imageLiteral(resourceName: "map_pin_orange")
        case .extreme:
            return #imageLiteral(resourceName: "map_pin_red")
        }
    }
    
    
    /// Try to play a sond based on the earthquake magnitude, for now just play the same sound until i find a better soud
    func playSound(){
        
        guard let magnitude = self.magnitude else {
            return
        }
        
        var soundUrl: URL? = Bundle.main.url(forResource: "default_earthquake", withExtension: "mp3")
        switch magnitude {
        case .low:
            if let _soundUrl = Bundle.main.url(forResource: "earthquake_low", withExtension: "mp3"){
                soundUrl = _soundUrl
            }
        case .moderate:
            if let _soundUrl = Bundle.main.url(forResource: "earthquake_moderate", withExtension: "mp3"){
                soundUrl = _soundUrl
            }
        case .high:
            if let _soundUrl = Bundle.main.url(forResource: "earthquake_high", withExtension: "mp3"){
                soundUrl = _soundUrl
            }
        case .extreme:
            if let _soundUrl = Bundle.main.url(forResource: "earthquake_extreme", withExtension: "mp3"){
                soundUrl = _soundUrl
            }
        }
        guard let url = soundUrl else {return}
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .defaultToSpeaker)
            let player = AVPlayer(url: url)
            player.volume = 1
            player.play()
        }catch let e{
            print(#function, #line, e)
        }
    }
}
