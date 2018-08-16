//
//  Reserva2.swift
//  Alba
//
//  Created by Bruno Rocca on 16/08/2018.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

//
//  Reserva2.swift
//  Alba
//
//  Created by Bruno Rocca on 16/08/2018.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import Foundation
import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var imageview: UIImageView!
    
    let images = ["Pipa", "Pipa1", "sefudeu"]
    var currentImage = 0
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?)
    {
        if event?.subtype == UIEventSubtype.motionShake
        {
            print ("SHAKE")
            imageview.image =  UIImage(named: images[currentImage] + ".png")
            
            if (currentImage == images.count-1)
            {
                currentImage = 0
            }
            else
            {
                currentImage+=1
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


