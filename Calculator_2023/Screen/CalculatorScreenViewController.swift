//
//  CalculatorViewController.swift
//  Calculator_2023
//
//  Created by Елена on 16.02.2023.
//

import UIKit

final class CalculatorScreenViewController: UIViewController {
    private enum Metrics {
        static let countCell = 19
        static let itemsInRow = 4
        static let lineSpace: CGFloat = 16
        static let itemSpace: CGFloat = 16
    }
    
    private var viewModel: CalculatorScreenViewModel
    var ui: CalculatorScreenView
    
    init(viewModel: CalculatorScreenViewModel) {
        self.ui = CalculatorScreenView(frame: .zero)
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        self.ui.setupCollectionView(delegate: self, dataOutput: self)
        
        self.setHandlers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = ui
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

}

extension CalculatorScreenViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Metrics.countCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalculatorScreenCollectionViewCell.reuseIdentifier, for: indexPath) as? CalculatorScreenCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.configure(with: TypeButtons.allCases[indexPath.row].rawValue)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath ) -> CGSize {
        
        let insetsSum = Metrics.itemSpace * (CGFloat(Metrics.itemsInRow) - 1)
        let otherSpace = collectionView.frame.width - insetsSum
        let cellWidth = otherSpace / CGFloat(Metrics.itemsInRow)
        
        if TypeButtons.allCases[indexPath.row] == TypeButtons.zero {
            return CGSize(width: 2 * cellWidth + Metrics.itemSpace, height: cellWidth)
        }
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Metrics.itemSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Metrics.lineSpace
    }
}

extension CalculatorScreenViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        self.viewModel.didSelectRow(at: indexPath)
    }
}

private extension CalculatorScreenViewController {
    func setHandlers() {
        self.ui.didSelectDeleteButtonHandler = { [weak self] in
            guard let self = self else { return }
            
            self.viewModel.didSelectDeleteButton()
        }
        
        self.viewModel.changedInput = { [weak self] firstNumber, actionMath, secondNumber in
            self?.ui.setInputExpression(firstNumber + actionMath + secondNumber)
        }
        
        self.viewModel.changedResultNumber = { [weak self] number in
            self?.ui.setResultNumberExpression(number)
            self?.ui.setInputExpression("")
        }
        
        self.viewModel.clearedData = { [weak self] in
            self?.ui.clearData()
        }
    }
}
