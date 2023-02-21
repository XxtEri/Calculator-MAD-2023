//
//  Presenter.swift
//  Calculator_2023
//
//  Created by Елена on 20.02.2023.
//

import Foundation

class CalculatorScreenPresenter {
    private var ui: CalculatorScreenView
    private var viewController: CalculatorScreenViewController?
    
    private var firstNumber = String()
    private var secondNumber = String()

    init() {
        self.ui = CalculatorScreenView()
    }
    
    func setViewController(vc: CalculatorScreenViewController) {
        self.viewController = vc
        
        self.setHandlers()
    }
}

private extension CalculatorScreenPresenter {
    func setHandlers() {
        self.viewController?.didSelectButtonHandler = { [weak self] typeButton in
            switch typeButton {
            case .ac:
                self?.ui.clearData()
            case .addition:
                print("addition")
            case .subtraction:
                print("subtraction")
            case .multiplication:
                print("multiplication")
            case .division:
                print("division")
            case .positiveNegative:
                print("ha")
            default:
                print("Number")
            }
        }
    }
    
    func additionNumber() {
        
    }
    
    func subtractionNumber() {
        
    }
    
    func multiplicationNumber() {
        
    }
    
    func divisionNumber() {
        
    }
}

