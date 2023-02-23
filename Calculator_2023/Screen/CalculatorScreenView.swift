//
//  View.swift
//  Calculator_2023
//
//  Created by Елена on 19.02.2023.
//

import UIKit
import SnapKit

class CalculatorScreenView: UIView {
    private lazy var titleApp: UILabel =  {
        let view = UILabel()
        view.text = "Calculator"
        view.textColor = UIColor(named: "TitleApp")
        view.textAlignment = .left
        view.font = UIFont(name: view.font.fontName, size: 28)

        return view
    }()
    
    private lazy var result: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.textColor = UIColor(named: "Answer")
        view.font = UIFont(name: view.font.fontName, size: 57)
        
        return view
    }()
    
    private lazy var input: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.textColor = UIColor(named: "Text")
        view.font = UIFont(name: view.font.fontName, size: 35)
        view.numberOfLines = 1
        
        return view
    }()
    
    private lazy var delete: UIImageView = {
        let view = UIImageView(image: UIImage(named: "DeleteButton"))
        view.contentMode = .scaleAspectFit
        view.tintColor = UIColor(named: "DeleteButton")
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private lazy var stackInput: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .horizontal
        
        return view
    }()
    
    private lazy var line: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor(named: "LineUnderInput")
        
        return view
    }()
    
    private lazy var buttons: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = UIColor(named: "BackgroundApp")
        
        view.register(CalculatorScreenCollectionViewCell.self, forCellWithReuseIdentifier: CalculatorScreenCollectionViewCell.reuseIdentifier)
        
        return view
    }()
    
    var didSelectDeleteButtonHandler: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleApp)
        self.addSubview(result)

        stackInput.addArrangedSubview(input)
        stackInput.addArrangedSubview(delete)
        stackInput.setCustomSpacing(25, after: input)
        
        self.addSubview(stackInput)
        self.addSubview(line)
        self.addSubview(buttons)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CalculatorScreenView {
    func setup() {
        configure()
        configureConstraints()
        configureActions()
    }
    
    func configure() {
        self.backgroundColor = UIColor(named: "BackgroundApp")
    }
    
    func configureConstraints() {
        self.titleApp.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(36)
            make.bottom.equalTo(result.snp.top).inset(-32.25)
        }
        
        self.result.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(70)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(self.stackInput.snp.top).inset(-39)
        }
        
        self.stackInput.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(48)
            make.leading.equalToSuperview().inset(24)
            make.trailing.equalToSuperview().inset(24)
        }
        
        self.line.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(stackInput.snp.bottom).inset(0)
        }
        
        self.buttons.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).inset(-16)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(45)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    func configureActions() {
        self.delete.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteBackNumber)))
    }
    
    @objc
    func deleteBackNumber() {
        self.didSelectDeleteButtonHandler?()
    }
    
}

extension CalculatorScreenView {
    func setupCollectionView(delegate: UICollectionViewDelegate, dataOutput: UICollectionViewDataSource) {
        buttons.delegate = delegate
        buttons.dataSource = dataOutput
    }
    
    func setInputNumber(_ number: String) {
        input.text = number
    }
    
    func setResultNumber(_ number: String) {
        result.text = number
        
        if number == "Error" {
            result.textColor = UIColor(named: "Error")
        }
    }
    
    func clearData() {
        input.text = String()
        result.text = String()
    }
}
