//
//  ViewController.swift
//  MyCalculator
//
//  Created by ShenIto on 25/02/2017.
//  Copyright © 2017 ShenIto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var sequence: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    var decimalPointTouched = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping && display.text! != "0" {
            let textCurrentInDisplay = display.text!
            display.text = textCurrentInDisplay + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
        
        
    }
    
    @IBAction func decimalPoint(_ sender: UIButton) {
        if !decimalPointTouched {
            if userIsInTheMiddleOfTyping {
                display.text = display.text! + "."
            } else {
                display.text = "0."
                userIsInTheMiddleOfTyping = true
            }
            decimalPointTouched = true
            sequence.text = sequence.text! + "."
        }
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain: CalculatorBrain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
            decimalPointTouched = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
        
        if brain.resultIsPending {
            sequence.text = brain.description! + " ..."
        } else {
            sequence.text = brain.description! + " ="
        }
        
    }
    
    @IBAction func touchClear(_ sender: UIButton) {
        brain.clear()
        userIsInTheMiddleOfTyping = false
        decimalPointTouched = false
        display.text = "0"
        sequence.text = " "
        brain.description = nil
        brain.originalDescription = nil
        brain.newOperand = nil
    }
    
}

