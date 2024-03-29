//
//  CalculatorScreenViewModel.swift
//  Calculator_2023
//
//  Created by Елена on 21.02.2023.
//

import Foundation

final class CalculatorScreenViewModel {
    
    // MARK: - Private properties
    
    private var inputNextNumber = false
    private var model: CalculatorScreenModel
    
    // MARK: - Public properties

    var changedInput: ((String, String, String) -> Void)?
    var changedResultNumber: ((String) -> Void)?
    var clearedData: (() -> Void)?
    
    // MARK: - Methods
    
    init() {
        self.model = CalculatorScreenModel()
    }
}

// MARK: - Private extension properties

private extension CalculatorScreenViewModel {
    func setNumber(_ expression: String) {
        guard expression.components(separatedBy: TypeButtons.comma.rawValue).count - 1 <= 1 else { return }
        
        guard expression.range(of: "^0{2,}", options: .regularExpression, range: nil, locale: nil) == nil else { return }
        
        guard expression.range(of: "^[,]", options: .regularExpression, range: nil, locale: nil) == nil else { return }
        
        if !inputNextNumber {
            model.firstNumber = expression
            
        } else {
            guard !model.actionMath.isEmpty else { return }
            
            model.secondNumber = expression
        }
        
        changedInput?(model.firstNumber, model.actionMath, model.secondNumber)
    }
    
    func getNumber() -> String {
        if inputNextNumber {
            return model.secondNumber
        }
        
        return model.firstNumber
    }
    
    func changeActionNumber(typeButton: TypeButtons) {
        guard !model.firstNumber.isEmpty else { return }
        
        if model.firstNumber == "-" {
            model.firstNumber.removeAll()
                
            changedInput?(model.firstNumber, model.actionMath, model.secondNumber)
            
        } else if !inputNextNumber {
            let endIndex = model.firstNumber.index(before: model.firstNumber.endIndex)
            
            if String(model.firstNumber[endIndex]) == TypeButtons.comma.rawValue {
                model.firstNumber += "0"
            }
            
            model.actionMath = typeButton.rawValue
            inputNextNumber = true
                
            changedInput?(model.firstNumber, model.actionMath, model.secondNumber)
            
        } else if model.secondNumber.isEmpty {
            model.actionMath = typeButton.rawValue
                
            changedInput?(model.firstNumber, model.actionMath, model.secondNumber)
            
        } else {
            convertNumbers()
            
            let result = model.result
            clearData()
            
            setNumber(result)

            changeActionNumber(typeButton: typeButton)
        }
    }
    
    func convertNumbers() {
        guard !model.firstNumber.isEmpty
                && !model.actionMath.isEmpty else { return }
        
        if model.secondNumber.isEmpty {
            model.secondNumber = model.firstNumber
        }
        
        if #available(iOS 16.0, *) {
            model.firstNumber.replace(",", with: ".")
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 16.0, *) {
            model.secondNumber.replace(",", with: ".")
        } else {
            // Fallback on earlier versions
        }
        
        if model.secondNumber.contains("(-") {
            model.secondNumber = model.secondNumber.replacingOccurrences(of: "[(]{1}", with: "", options: .regularExpression)
        }

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
        
        switch model.actionMath {
        case TypeButtons.addition.rawValue:
            result = String(num1 + num2)
        case TypeButtons.subtraction.rawValue:
            result = String(num1 - num2)
        case TypeButtons.multiplication.rawValue:
            result = String(num1 * num2)
        case TypeButtons.division.rawValue:
            if num2 == 0 {
                result = "Error"
            } else {
                result = String(num1 / num2)
            }
        case TypeButtons.percent.rawValue:
            result = String(num1 * num2 / 100)
        default:
            print("error")
        }
        
        if #available(iOS 16.0, *) {
            result.replace(".", with: ",")
        } else {
            // Fallback on earlier versions
        }
        
        if result.range(of: ".+[,][0]{1}.+", options: .regularExpression, range: nil, locale: nil) == nil {
            result = result.replacingOccurrences(of: "[,][0]{1}", with: "", options: .regularExpression)
        }
        
        if result == "-0" {
            result = "0"
        }
        
        model.result = result
        
        changedResultNumber?(model.result)
    }
    
    func changeSignOfNumber() {
        let curNumber = getNumber()
        
        if !inputNextNumber && !curNumber.isEmpty && curNumber[curNumber.startIndex] == "-" {
            
            var newNumber = curNumber
            newNumber.remove(at: curNumber.startIndex)
            
            setNumber(newNumber)
            
        } else if inputNextNumber {
            if curNumber.contains("(-") {
                let newNumber = curNumber.replacingOccurrences(of: "[(]{1}[-]{1}", with: "", options: .regularExpression)
                
                setNumber(newNumber)
                return
            }
            
            switch model.actionMath {
            case TypeButtons.addition.rawValue:
                model.actionMath = TypeButtons.subtraction.rawValue
                changedInput?(model.firstNumber, model.actionMath, model.secondNumber)
            case TypeButtons.subtraction.rawValue:
                model.actionMath = TypeButtons.addition.rawValue
                changedInput?(model.firstNumber, model.actionMath, model.secondNumber)
            case TypeButtons.multiplication.rawValue, TypeButtons.division.rawValue:
                setNumber("(-" + curNumber)
            default:
                print("error")
            }
            
        } else {
            setNumber("-" + curNumber)
        }
    }
    
    func clearData() {
        model.firstNumber = String()
        model.secondNumber = String()
        model.actionMath = String()
        model.result = String()
        
        inputNextNumber = false
    }
}

// MARK: - Public extension properties

extension CalculatorScreenViewModel {
    func didSelectRow(at indexPath: IndexPath) {
        let typeButton = TypeButtons.allCases[indexPath.row]
        
        switch typeButton {
        case .ac:
            clearData()
            clearedData?()
        case .percent, .addition, .subtraction, .multiplication, .division:
            changeActionNumber(typeButton: typeButton)
        case .equal:
            convertNumbers()
            clearData()
        case .positiveNegative:
            changeSignOfNumber()
        default:
            let curNumber = getNumber()
            setNumber(curNumber + typeButton.rawValue)
        }
    }
    
    func didSelectDeleteButton() {
        var number = ""
        
        if !inputNextNumber {
            number = model.firstNumber
            
        } else {
            number = model.secondNumber
        }
        
        guard !number.isEmpty else {return}
        
        number.remove(at: number.index(before: number.endIndex))
        setNumber(number)
    }
}
