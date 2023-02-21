//
//  CalculatorScreenBuisnessLogic.swift
//  Calculator_2023
//
//  Created by Елена on 21.02.2023.
//

protocol ICalculatorScreenBuisnessLogic {
    func setNumber(_ number: String)
    func getNumber() -> String
    func getResult() -> String
    func clearData()
    
    func deleteBackOneNumber()
    func additionNumbers()
    func subtractionNumbers()
    func multiplicationNumbers()
    func divisionNumbers()
}

class CalculatorScreenBuisnessLogic {
    private var firstNumber = String()
    private var secondNumber = String()
    
    private var result = String()
    
    var inputNextNumber = false
}

extension CalculatorScreenBuisnessLogic: ICalculatorScreenBuisnessLogic {
    func setNumber(_ number: String) {
        if !self.inputNextNumber {
            self.firstNumber += number
            
        } else {
            self.secondNumber += number
        }
    }
    
    func getNumber() -> String {
        if !self.inputNextNumber {
            return self.firstNumber
        }
        
        return self.secondNumber
    }
    
    func deleteBackOneNumber() {
        if !self.inputNextNumber {
            firstNumber.remove(at: firstNumber.index(before: firstNumber.endIndex))
            
        } else {
            secondNumber.remove(at: firstNumber.index(before: firstNumber.endIndex))
        }
    }
    
    func additionNumbers() {
        
    }
    
    func subtractionNumbers() {
        
    }
    
    func multiplicationNumbers() {
        
    }
    
    func divisionNumbers() {
        
    }
    
    func getResult() -> String {
        return ""
    }
    
    func clearData() {
        self.firstNumber = String()
        self.secondNumber = String()
        self.result = String()
        self.inputNextNumber = false
    }
}
