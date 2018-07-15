//
//  ViewController.swift
//  Facade
//
//  Created by Bapusaheb Patil on July 14,2018.
//  Copyright © 2018 Bapusaheb Patil. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var creationFrame: UIView!
    @IBOutlet weak var creationImageView: UIImageView!
    @IBOutlet weak var startOverButton: UIButton!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var colorsContainer: UIView!
    @IBOutlet weak var shareButton: UIButton!
    
    var creation = Creation.init()
    
    @IBAction func startOver(_ sender: Any) {
    }
    
    @IBAction func applyColor(_ sender: UIButton) {
        print("Applying color...")
    }
    
    @IBAction func share(_ sender: Any) {
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

