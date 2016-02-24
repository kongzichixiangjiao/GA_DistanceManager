//
//  ViewController.swift
//  GA_DistanceManager
//
//  Created by houjianan on 16/2/23.
//  Copyright © 2016年 houjianan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let t = GA_TextField(frame: CGRectMake(20, 100, 300, 30), delegate: self)
        t.tag = 111
        self.view.addSubview(t)
    }

    @IBAction func updateM(sender: UIButton) {
        let t = self.view.viewWithTag(111) as! GA_TextField
        t.update(.MIDDLE)
    }
    
    @IBAction func updateL(sender: UIButton) {
        let t = self.view.viewWithTag(111) as! GA_TextField
        t.update(.LEFT, hasCancleButton: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: GA_TextFieldDelegate {
    func myTextFieldDidBeginEditing(textField: UITextField) {
        print("2")
    }
    
    func myTextFieldShouldBeginEditing(textField: UITextField) {
    
    }
    
    func myTextFieldShouldReturn(text: String) {
    
    }
    
    func cancleButton() {
        print("cancleButton")
    }
}
