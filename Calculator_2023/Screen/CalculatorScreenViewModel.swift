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
    
    private var actionMath: TypeButtons?
    
    var changedInputNumber: ((String) -> Void)?
    var changedResultNumber: ((String) -> Void)?
    var clearedData: (() -> Void)?
    
    init() {
        self.model = CalculatorScreenModel()
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        let typeButton = TypeButtons.allCases[indexPath.row]
        
        switch typeButton {
        case .ac:
            clearData()
            clearedData?()
        case .percent, .addition, .subtraction, .multiplication, .division:
            selectActionNumber(typeButton: typeButton)
        case .equal:
            convertNumbers()
        case .positiveNegative:
            changeSignOfNumber()
        default:
            let cur_number = getNumber()
            setNumber(cur_number + typeButton.rawValue)
        }
    }
    
    func didSelectDeleteButton() {
        var number = ""
        
        if !inputNextNumber {
            number = model.firstNumber
            
        } else {
            number = model.secondNumber
        }
        
        number.remove(at: number.index(before: number.endIndex))
        setNumber(number)
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
    
    func selectActionNumber(typeButton: TypeButtons) {
        inputNextNumber = true
        actionMath = typeButton
        changedInputNumber?(getNumber())
    }
    
    func convertNumbers() {
        guard !model.firstNumber.isEmpty
                && !model.secondNumber.isEmpty
                && actionMath != nil else { return }
        
        model.firstNumber.replace(",", with: ".")
        model.secondNumber.replace(",", with: ".")

        var firstNumber: Float = 0
        var secondNumber: Float = 0
        
        if let number = Float(model.firstNumber) {
            firstNumber = number
        }
        
        if let number = Float(model.secondNumber) {
            secondNumber = number
        }
        
        performActionMath(firstNumber, secondNumber)
    }
    
    func performActionMath(_ num1: Float, _ num2: Float) {
        var result = ""
        
        switch actionMath {
        case .addition:
            result = String(num1 + num2)
        case .subtraction:
            result = String(num1 - num2)
        case .multiplication:
            result = String(num1 * num2)
        case .division:
            result = String(num1 / num2)
        case .percent:
            result = String(num1 / 100 * num2)
        default:
            print("error")
        }
        
        result = result.replacingOccurrences(of: ".0{1}", with: "", options: .regularExpression)
        result.replace(".", with: ",")
        model.result = result
        
        changedResultNumber?(model.result)
        clearData()
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
