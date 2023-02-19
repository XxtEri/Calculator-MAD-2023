//
//  ButtonCollectionViewCell.swift
//  Calculator_2023
//
//  Created by Елена on 19.02.2023.
//

import UIKit

class ButtonCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ButtonCollectionViewCell"
    
    lazy var titleCell: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: view.font.fontName, size: 32)
        view.textColor = UIColor(named: "Text")
        view.textAlignment = .center
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleCell)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String) {
        self.titleCell.text = title
        
        if title == TypeButtons.division.rawValue ||
            title == TypeButtons.multiplication.rawValue ||
            title == TypeButtons.subtraction.rawValue ||
            title == TypeButtons.addition.rawValue ||
            title == TypeButtons.equal.rawValue {
            self.backgroundColor = UIColor(named: "SecondBackgroundCell")
        } else {
            self.backgroundColor = UIColor(named: "FirstBackgroundCell")
        }
    }
}

private extension ButtonCollectionViewCell {
    func setup() {
        self.configureCard()
        self.configureConstraints()
    }
    
    func configureCard() {
        self.layer.cornerRadius = 24
        self.clipsToBounds = true
    }
    
    func configureConstraints() {
        titleCell.snp.makeConstraints({ make in
            make.horizontalEdges.equalToSuperview().inset(11.88)
            make.verticalEdges.equalToSuperview().inset(14.88)
        })
    }
}
