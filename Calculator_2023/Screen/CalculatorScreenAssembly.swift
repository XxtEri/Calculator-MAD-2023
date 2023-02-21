//
//  CalculatorScreenAssembly.swift
//  Calculator_2023
//
//  Created by Елена on 20.02.2023.
//

import UIKit

enum CalculatorScreenAssembly {
    static func build() -> UIViewController {
        let presenter = CalculatorScreenPresenter()
        let viewContoller = CalculatorScreenViewController(presenter: presenter)
        
        presenter.setViewController(vc: viewContoller)
        
        return viewContoller
    }
}
