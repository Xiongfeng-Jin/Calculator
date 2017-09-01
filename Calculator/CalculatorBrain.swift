//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Jin on 7/26/17.
//  Copyright © 2017 Jin. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double)->Double)
        case binaryOperation((Double,Double)->Double)
        case equals
    }
    
    private var operations = [
        "π":Operation.constant(Double.pi),
        "e":Operation.constant(M_E),
        "√":Operation.unaryOperation(sqrt),
        "cos":Operation.unaryOperation(cos),
        "±":Operation.unaryOperation({-$0}),
        "*": Operation.binaryOperation(*),
        "+": Operation.binaryOperation(+),
        "-": Operation.binaryOperation(-),
        "/": Operation.binaryOperation(/),
        "=":Operation.equals
    ]
    
    mutating func performOperation(_ symbal: String) {
        if let operation = operations[symbal]{
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let funcion):
                if let accu = accumulator{
                    accumulator = funcion(accu)
                }
            case .binaryOperation(let function):
                performPendingBinaryOperation()
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                        accumulator = nil
                }
                else{
                    if pendingBinaryOperation != nil {
                        pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: (pendingBinaryOperation?.firstOperand)!)
                    }
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation(){
        if pendingBinaryOperation != nil && accumulator != nil{
            accumulator = pendingBinaryOperation?.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation{
        let function: (Double,Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand,secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double?{
        get{
            if accumulator != nil{
                return accumulator
            }
            if pendingBinaryOperation != nil {
                return pendingBinaryOperation?.firstOperand
            }
            return accumulator
        }
    }
    
}
