//
//  ScoreFinal.swift
//  Alba
//
//  Created by Letícia Siqueira on 21/08/2018.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import UIKit

class ScoreFinal: UIViewController {

    @IBOutlet weak var scoreFinal: UILabel!
    
    var dadoRecebido = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreFinal.text = "\(PhysicsCategory.score)"
        PhysicsCategory.score = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
  
    }



}
