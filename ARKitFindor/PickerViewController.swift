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
    
    var panGesture       = UIPanGestureRecognizer()
    
    @IBOutlet weak var swipBtn: UIImageView!
    let positions = ["WC +":(x:Float(45),y:Float(6)),"Entrance":(x:Float(24.5),y:Float(7)),"Main Space":(x:Float(21),y:Float(13)),"Workshop Space":(x:Float(2),y:Float(4))]

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedView(_:)))
        swipBtn.isUserInteractionEnabled = true
        swipBtn.addGestureRecognizer(panGesture)
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
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let string = Array(positions.keys)[row]
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        self.view.bringSubviewToFront(swipBtn)
        let translation = sender.translation(in: self.view)
        if (swipBtn.center.x + translation.x) > 80 {
            swipBtn.center = CGPoint(x: swipBtn.center.x + translation.x, y: swipBtn.center.y)
        }
        if swipBtn.center.x + translation.x >= 304 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AR") as! ViewController
            if destination == nil {
                destination = Array(positions.values)[0]
            }
            vc.destinationPosition = destination
            vc.originPosition = positions[originString]
            present(vc, animated: true, completion: nil)
        }
        print(swipBtn.center.x + translation.x)
        sender.setTranslation(CGPoint.zero, in: self.view)
    }

    
    @IBAction func panView(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        
        if let viewToDrag = sender.view {
            viewToDrag.center = CGPoint(x: viewToDrag.center.x + translation.x,
                                        y: viewToDrag.center.y + translation.y)
            sender.setTranslation(CGPoint(x: 0, y: 0), in: viewToDrag)
        }
    }

    @IBAction func nextAction(_ sender: Any) {
        

    }
}
