//
//  ViewController.swift
//  Calculator
//
//  Created by 鍾妘 on 2017/4/12.
//  Copyright © 2017年 soslab. All rights reserved.
//

import UIKit
import CalculatorCore

extension Double {
    
    fileprivate var displayString: String {
        
        let floor = self.rounded(.towardZero)
        let isInteger = self.distance(to: floor).isZero
        
        let string = String(self)
        if isInteger {
            
            if let indexOfDot = string.characters.index(of: ".") {
           
                return string.substring(to: indexOfDot)
            }
        }
 
        return String(self)
    }
}

class ViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var displayLabel: UILabel!

    var core = Core<Double>()
    var numberOfOperatorClicked = 0
    var operatorIsClicked = false
    var rootOperatorClicked = false
    
    // MARK: - Input
    
    @IBAction func numericButtonClicked(_ sender: UIButton) {
    
        let numericButtonDigit = sender.tag - 1000
        let digitText = "\(numericButtonDigit)"
     
        let currentText = self.displayLabel.text ?? "0"
        if currentText == "0" {
            self.displayLabel.text = digitText
        } else  {
            if self.operatorIsClicked {
                self.displayLabel.text = digitText
                self.operatorIsClicked = false
                self.numberOfOperatorClicked = 0
            } else {
                self.displayLabel.text = currentText + digitText
            }
        }
    }
    
    @IBAction func dotButtonClicked(_ sender: UIButton) {
        let currentText = self.displayLabel.text ?? "0"
        
        guard !currentText.contains(".") else {
            return
        }
       
        self.displayLabel.text = currentText + "."
    }
    
    @IBAction func clearButtonClicked(_ sender: UIButton) {
        // Clear (Reset)
        // 1. Clean the display label
        self.displayLabel.text = "0"
        self.numberOfOperatorClicked = 0
        self.operatorIsClicked = false
        // 2. Reset the core
        self.core = Core<Double>()
    }
    
    @IBAction func piButtonClicked(_ sender: Any) {
        self.displayLabel.text = String(Double.pi)
    }
    
    @IBAction func eButtonClicked(_ sender: Any) {
        self.displayLabel.text = String(M_E)
    }
    
    @IBAction func percentageButtonClicked(_ sender: Any) {
        let currentNumber = Double(self.displayLabel.text ?? "0")!
        if currentNumber == 0 {
            return
        } else {
            self.displayLabel.text = String(currentNumber / 100)
        }
    }
    
    @IBAction func signButtonClicked(_ sender: Any) {
        let currentNumber = Double(self.displayLabel.text ?? "0")!
        if currentNumber == 0 {
            return
        } else if currentNumber > 0 {
            self.displayLabel.text = "-" + currentNumber.displayString
        } else {
            self.displayLabel.text = (-currentNumber).displayString
        }
    }
    
    // MARK: - Actions
    
    @IBAction func operatorButtonClicked(_ sender: UIButton) {
        
        self.operatorIsClicked = true
        self.numberOfOperatorClicked += 1
        
        // Here, I use tag to check whether the button it is.
        if self.numberOfOperatorClicked == 1  {
            // Add current number into the core as a step
            let currentNumber = Double(self.displayLabel.text ?? "0")!
            if self.rootOperatorClicked {
                try! self.core.addStep(1 / currentNumber)
                self.rootOperatorClicked = false
            } else {
                try! self.core.addStep(currentNumber)
            }
            // Get and show the result
            let result = self.core.calculate()!
            self.displayLabel.text = result.displayString
            
            switch sender.tag {
            case 1101: // Add
                try! self.core.addStep(+)
            case 1102: // Sub
                try! self.core.addStep(-)
            case 1103: // Multiply
                try! self.core.addStep(*)
            case 1104: // Divide
                try! self.core.addStep(/)
            case 1105: // Pow
                try! self.core.addStep(pow)
            case 1106: // Root
                try! self.core.addStep(pow)
                self.rootOperatorClicked = true
            case 1107: // Log10
                self.displayLabel.text = String(log10(result).displayString)
                self.core = Core<Double>()
                self.numberOfOperatorClicked = 0
                self.operatorIsClicked = false
            default:
                fatalError("Unknown operator button: \(sender)")
            }

        } else {
            return
        }
    }
    
    @IBAction func calculateButtonClicked(_ sender: UIButton) {
        // Add current number into the core as a step
        let currentNumber = Double(self.displayLabel.text ?? "0")!
        if self.rootOperatorClicked {
            try! self.core.addStep(1 / currentNumber)
            self.rootOperatorClicked = false
        } else {
            try! self.core.addStep(currentNumber)
        }
        // Get and show the result
        let result = self.core.calculate()!
        self.displayLabel.text = result.displayString
        // Reset the core
        self.numberOfOperatorClicked = 0
        self.operatorIsClicked = false
        self.core = Core<Double>()
    }


}

