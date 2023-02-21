//
//  CalculatorScreenViewModel.swift
//  Calculator_2023
//
//  Created by Елена on 21.02.2023.
//

import Foundation

final class CalculatorScreenViewModel {
    private var inputNextNumber = false
    private var model: CalculatorScreenModel
    
    var didSelectButtonHandler: ((TypeButtons) -> Void)?
    var didSelectDeleteButtonHandler: (() -> Void)?
    
    var changedInputNumber: ((String) -> Void)?
    var changedResultNumber: ((String) -> Void)?
    var clearedData: (() -> Void)?
    
    init() {
        self.model = CalculatorScreenModel()
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        let number = TypeButtons.allCases[indexPath.row]
        switch number {
        case .ac:
            clearData()
            clearedData?()
        case .addition:
            print("addition")
        case .subtraction:
            print("subtraction")
        case .multiplication:
            print("multiplication")
        case .division:
            print("division")
        case .positiveNegative:
            changeSignOfNumber()
            print("ha")
        default:
            let cur_number = getNumber()
            setNumber(cur_number + number.rawValue)
        }
    }
}

private extension CalculatorScreenViewModel {
    func setNumber(_ number: String) {
        if !inputNextNumber {
            model.firstNumber = number
            
        } else {
            model.secondNumber = number
        }
        
        changedInputNumber?(self.getNumber())
    }
    
    func getNumber() -> String {
        if !inputNextNumber {
            return model.firstNumber
        }
        
        return model.secondNumber
    }
    
    func deleteBackOneNumber() {
        if !inputNextNumber {
            model.firstNumber.remove(at: model.firstNumber.index(before: model.firstNumber.endIndex))
            
        } else {
            model.secondNumber.remove(at: model.firstNumber.index(before: model.firstNumber.endIndex))
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
    
    func changeSignOfNumber() {
        let curNumber = getNumber()
        
        if curNumber[curNumber.startIndex] == "-" {
            var newNumber = curNumber
            newNumber.remove(at: curNumber.startIndex)
            
            setNumber(newNumber)
            
        } else {
            setNumber("-" + curNumber)
        }
    }
    
    func getResult() -> String {
        return model.result
    }
    
    func clearData() {
        model.firstNumber = String()
        model.secondNumber = String()
        model.result = String()
        
        inputNextNumber = false
    }
}
