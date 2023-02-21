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
    private var buisnessLogic: ICalculatorScreenBuisnessLogic

    init(buisnessLogic: ICalculatorScreenBuisnessLogic) {
        self.ui = CalculatorScreenView()
        self.buisnessLogic = buisnessLogic
    }
    
    func setViewController(vc: CalculatorScreenViewController) {
        self.viewController = vc
        
        self.setHandlers()
    }
}

private extension CalculatorScreenPresenter {
    func setHandlers() {
        self.viewController?.didSelectDeleteButtonHandler = { [weak self] in
            self?.buisnessLogic.deleteBackOneNumber()
            if let number = self?.buisnessLogic.getNumber() {
                print(number)
                self?.ui.setInputNumber(number)
            }
        }
        
        self.viewController?.didSelectButtonHandler = { [weak self] typeButton in
            switch typeButton {
            case .ac:
                self?.ui.clearData()
                self?.buisnessLogic.clearData()
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
                self?.buisnessLogic.setNumber(typeButton.rawValue)
                if let number = self?.buisnessLogic.getNumber() {
                    print(number)
                    self?.ui.setInputNumber(number)
                }
                print("number")
            }
        }
    }
}

