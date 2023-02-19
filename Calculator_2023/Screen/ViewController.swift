//
//  ViewController.swift
//  Calculator_2023
//
//  Created by Елена on 16.02.2023.
//

import UIKit

class ViewController: UIViewController {
    private enum Metrics {
        static let itemsInRow = 4
        static let lineSpace: CGFloat = 16
        static let itemSpace: CGFloat = 16
    }
    
    private var ui: View

    var didSelectButtonHandler: ((TypeButtons) -> Void)?
    
    init() {
        self.ui = View(frame: .zero)
        
        super.init(nibName: nil, bundle: nil)
        
        self.ui.setupCollectionView(delegate: self, dataOutput: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = ui
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.logicCaluclator()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

}

extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        19
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.reuseIdentifier, for: indexPath) as? ButtonCollectionViewCell else {
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

extension ViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        self.didSelectButtonHandler?(TypeButtons.allCases[indexPath.row])
    }
}

private extension ViewController {
    func logicCaluclator() {
        self.didSelectButtonHandler = { [weak self] typeButton in
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
                self?.ui.changePositiveNegative()
            default:
                self?.ui.setNumber(typeButton.rawValue)
                print("Number")
            }
        }
    }
}
