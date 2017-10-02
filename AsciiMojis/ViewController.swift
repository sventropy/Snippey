//
//  ViewController.swift
//  AsciiMojis
//
//  Created by Hennessen, Sven on 14.09.17.
//  Copyright © 2017 Hennessen, Sven. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // gradient similar to app icon
        let topColor = UIColor(red: 234/255, green: 88/255, blue: 43/255, alpha: 1)
        let bottomColor = UIColor(red: 138/255, green: 75/255, blue: 39/255, alpha: 1)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var prefersStatusBarHidden: Bool{
        return true
    }
}

