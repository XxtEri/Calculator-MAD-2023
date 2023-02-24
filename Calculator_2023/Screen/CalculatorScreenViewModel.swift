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

    var changedInput: ((String, String, String) -> Void)?
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
            changeActionNumber(typeButton: typeButton)
        case .equal:
            convertNumbers()
            clearData()
        case .positiveNegative:
            changeSignOfNumber()
        default:
            setNumber(typeButton.rawValue)
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

//исправить с проставлением минуса во втором числе при динамическом просчитывании чисел
//если второе число не ввели, но есть мат знак, то берем и вычисляем результат с результатом
//пробела, когда два раза вводишь мат знак

//изменить на подставку выражения, а не числа куда-то
private extension CalculatorScreenViewModel {
    func setNumber(_ number: String) {
        if !inputNextNumber {
            if model.firstNumber.contains(TypeButtons.comma.rawValue) &&
                    number == TypeButtons.comma.rawValue { return }
            
            let curNumber = getNumber()
            model.firstNumber = curNumber + number
            
        } else {
            guard !model.actionMath.isEmpty else { return }
            if model.secondNumber.contains(TypeButtons.comma.rawValue) &&
                    number == TypeButtons.comma.rawValue { return }
            
            let curNumber = getNumber()
            model.secondNumber = curNumber + number
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
        
        model.actionMath = typeButton.rawValue
        
        if !inputNextNumber {
            let endIndex = model.firstNumber.index(before: model.firstNumber.endIndex)
            
            if String(model.firstNumber[endIndex]) == TypeButtons.comma.rawValue {
                model.firstNumber += "0"
            }
                
            changedInput?(model.firstNumber, model.actionMath, model.secondNumber)
            inputNextNumber = true
            
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
                && !model.secondNumber.isEmpty
                && !model.actionMath.isEmpty else { return }
        
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
            result = String(num1 / 100 * num2)
        default:
            print("error")
        }
        if result.range(of: ".*([.][0]{1})", options: .regularExpression, range: nil, locale: nil) != nil {
            result = result.replacingOccurrences(of: "[.][0]{1}", with: "", options: .regularExpression)
        } else {
            result.replace(".", with: ",")
        }
        
        model.result = result
        
        changedResultNumber?(model.result)
    }
    
    func changeSignOfNumber() {
        let curNumber = getNumber()
        
        if !curNumber.isEmpty && !inputNextNumber && curNumber[curNumber.startIndex] == "-" {
            
            var newNumber = curNumber
            newNumber.remove(at: curNumber.startIndex)
            
            setNumber(newNumber)
            
        } else if curNumber.isEmpty && inputNextNumber {
            setNumber("-" + curNumber)
            
        } else if !curNumber.isEmpty && inputNextNumber {
            if curNumber.contains("[(-)]") {
                let newNumber = curNumber.replacingOccurrences(of: "[()-]", with: "", options: .regularExpression)
                
                setNumber(newNumber)
                return
            }
            
            switch model.actionMath {
            case TypeButtons.addition.rawValue:
                changeActionNumber(typeButton: TypeButtons.subtraction)
            case TypeButtons.subtraction.rawValue:
                changeActionNumber(typeButton: TypeButtons.addition)
            case TypeButtons.multiplication.rawValue, TypeButtons.division.rawValue:
                setNumber("(-" + curNumber + ")")
            default:
                print("error")
            }

        } else {
            setNumber("-")
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
