//
//  Reserva2.swift
//  Alba
//
//  Created by Bruno Rocca on 16/08/2018.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import Foundation
import AudioKit
import AudioKitUI

class BlowIdentifier{
    var mic: AKMicrophone!
    var tracker: AKFrequencyTracker!
    var silence: AKBooster!
    
    init() {
        AKSettings.audioInputEnabled = true
        mic = AKMicrophone()
        
        
        
        tracker = AKFrequencyTracker(mic)
        silence = AKBooster(tracker, gain: 0)
        
        AudioKit.output = silence
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start!")
        }
        
    }
    func getAmplitude() -> Int{
        if(tracker.amplitude > 0.5){
            return 3
        }
        if(tracker.amplitude > 0.4){
            return 2
        }
        if(tracker.amplitude > 0.3){
            return 1
        }
        
        return 0
        
    }
    func stop(){
        mic.stop()
        AudioKit.disconnectAllInputs()
        //self.audioInputPlot.
    }
    
    @objc func updateUI(){
        if(tracker.amplitude > 0.1){
        
            print("AMPLITUDE DO BAGUIU:", tracker.amplitude)
        }
    }
    
    
    
}
