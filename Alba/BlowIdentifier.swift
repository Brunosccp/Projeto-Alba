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
    @IBOutlet private var audioInputPlot: EZAudioPlot!
    
    
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
//        Timer.scheduledTimer(timeInterval: 0.01,
//                             target: self,
//                             selector: #selector(updateUI),
//                             userInfo: nil,
//                             repeats: true)
        
        
    }
    func getAmplitude() -> Int{
        if(tracker.amplitude > 0.3){
            return 3
        }
        if(tracker.amplitude > 0.2){
            return 2
        }
        if(tracker.amplitude > 0.1){
            return 1
        }
        
        return 0
        
    }
    
    @objc func updateUI(){
        if(tracker.amplitude > 0.1){
        
            print("AMPLITUDE DO BAGUIU:", tracker.amplitude)
        }
    }
    
    
    
}
