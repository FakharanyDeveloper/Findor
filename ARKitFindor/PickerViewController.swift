//
//  PickerViewController.swift
//  ARKitFindor
//
//  Created by Khaled Fakharany on 10/3/19.
//  Copyright © 2019 Khaled Fakharany. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var originString: String!
    var destination: (x:Float,y:Float)!
    
    let positions = ["WC":(x:Float(45),y:Float(6)),"Entrance":(x:Float(24.5),y:Float(7)),"Door1":(x:Float(21),y:Float(13)),"Door2":(x:Float(2),y:Float(4))]

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return positions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(positions.keys)[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        destination = Array(positions.values)[row]
    }

    
    

    @IBAction func nextAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AR") as! ViewController
        if destination == nil {
            destination = Array(positions.values)[0]
        }
        vc.destinationPosition = destination
        vc.originPosition = positions[originString]
        present(vc, animated: true, completion: nil)

    }
}
