//
//  HomeViewController.swift
//  ARKitFindor
//
//  Created by Khaled Fakharany on 10/3/19.
//  Copyright © 2019 Khaled Fakharany. All rights reserved.
//

import UIKit
import TransitionButton

class HomeViewController: UIViewController {

    @IBOutlet weak var scanBtn: TransitionButton!
    @IBOutlet weak var scanLive: TransitionButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scanBtn.backgroundColor = UIColor(displayP3Red: 237/255, green: 168/255, blue: 38/255, alpha: 1)
        scanBtn.setTitle("Scan QR Code", for: .normal)
        scanBtn.cornerRadius = 20
        scanBtn.spinnerColor = .white
        
        scanLive.backgroundColor = UIColor(displayP3Red: 237/255, green: 168/255, blue: 38/255, alpha: 1)
        scanLive.setTitle("Scan Anchors", for: .normal)
        scanLive.cornerRadius = 20
        scanLive.spinnerColor = .white
    }
    
    @IBAction func scanPressed(_ sender: Any) {
        
        scanBtn.startAnimation()
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            
            sleep(1)
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.scanBtn.stopAnimation(animationStyle: .expand, completion: {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "QRVC") as! QRViewController
                    self.present(vc, animated: true, completion: nil)
                })
            })
        })
        
        
        
    }
    @IBAction func scanLivePressed(_ sender: Any) {
        scanLive.startAnimation()
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            
            sleep(1)
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.scanLive.stopAnimation(animationStyle: .expand, completion: {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "AR2") as! ViewController
                    self.present(vc, animated: true, completion: nil)
                })
            })
        })
    }
}
