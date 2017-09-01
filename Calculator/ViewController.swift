//
//  ViewController.swift
//  Calculator
//
//  Created by Jin on 7/26/17.
//  Copyright © 2017 Jin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel?
    var userIsInTheMiddleOfTyeing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyeing {
            let textCurrentInDisplay = display!.text!
            display!.text = textCurrentInDisplay + digit
        }
        else{
            display!.text = digit
            userIsInTheMiddleOfTyeing = true
        }
        
    }
    
    var displayValue: Double{
        get{
            return Double(display!.text!)!
        }
        set{
            display?.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyeing {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyeing = false
        }
        if let mathematicalSymbal = sender.currentTitle{
            brain.performOperation(mathematicalSymbal)
        }
        if let result = brain.result{
            displayValue = result
        }
    }
    
    
    
    
}

