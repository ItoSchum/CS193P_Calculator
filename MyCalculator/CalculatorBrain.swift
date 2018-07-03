//
//  File.swift
//  MyCalculator
//
//  Created by ShenIto on 25/02/2017.
//  Copyright © 2017 ShenIto. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    
    private enum Operation {                                    // OpType Enum
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary <String,Operation> = [    // OpType Dictionary
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "%" : Operation.unaryOperation({ $0 / 100 }),
        "sin" : Operation.unaryOperation(sin),
        "cos" : Operation.unaryOperation(cos),
        "tan" : Operation.unaryOperation(tan),
        "±" : Operation.unaryOperation({ -$0 }),
        "+" : Operation.binaryOperation({ $0 + $1 }),
        "-" : Operation.binaryOperation({ $0 - $1 }),
        "×" : Operation.binaryOperation({ $0 * $1 }),
        "÷" : Operation.binaryOperation({ $0 / $1 }),
        "=" : Operation.equals
    ]
    
    mutating func performOperation(_ symbol: String) {          // OpType's Ops
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
                
                if description != nil {
                    description = description! + " " + symbol
                } else {
                    description = symbol
                }
                
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                    
                    if description != nil {
                        if resultIsPending {
                            description = originalDescription! + symbol + "(" + newOperand! + ")"
                        } else {
                            description = symbol +  "(" + description! + ")"
                        }
                    } else {
                        description = symbol
                    }
                    
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    resultIsPending = true
                    binaryOperationSet = true
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                    
                    if description != nil {
                        description = description! + " " + symbol
                    } else {
                        description = symbol
                    }
                    
                }
            case .equals:
                performPendingBinaryOperation()
                resultIsPending = false
                binaryOperationSet = false
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {         // performPendingBinaryOps
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double,Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand (_ sender: Double) {                   // Operand INPUT
        accumulator = sender
        
        if description != nil {
            if !binaryOperationSet && !resultIsPending {
                description = String(accumulator!)
            } else {
                newOperand = String(accumulator!)
                originalDescription = description!
                description = description! + " " + String(accumulator!)
            }
        } else {
            description = String(accumulator!)
        }
        
    }
    
    mutating func clear () {                                        // CLEAR Op
        accumulator = nil
        pendingBinaryOperation = nil
        resultIsPending = false
    }
    
    var binaryOperationSet = false
    var resultIsPending = false
    var originalDescription: String?
    var newOperand: String?
    var description: String?
    var result: Double? {                                           // result OUTPUT
        get {
            return accumulator
        }
    }
    
}
