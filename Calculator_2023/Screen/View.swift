//
//  View.swift
//  Calculator_2023
//
//  Created by Елена on 19.02.2023.
//

import UIKit
import SnapKit

class View: UIView {
    lazy var titleApp: UILabel =  {
        let view = UILabel()
        view.text = "Calculator"
        view.textColor = UIColor(named: "TitleApp")
        view.textAlignment = .left
        view.font = UIFont(name: view.font.fontName, size: 28)

        return view
    }()
    
    lazy var result: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.text = "8912"
        view.textColor = UIColor(named: "Answer")
        view.font = UIFont(name: view.font.fontName, size: 57)
        
        return view
    }()
    
    lazy var stackInput: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .vertical
        
        return view
    }()
    
    lazy var buttons: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = UIColor(named: "BackgroundApp")
        view.register(ButtonCollectionViewCell.self, forCellWithReuseIdentifier: ButtonCollectionViewCell.reuseIdentifier)
        
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.titleApp)
        self.addSubview(self.result)

        self.addViewInStack()
        self.addSubview(self.stackInput)
        
        self.addSubview(self.buttons)
        
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension View {
    func setupCollectionView(delegate: UICollectionViewDelegate, dataOutput: UICollectionViewDataSource) {
        self.buttons.delegate = delegate
        self.buttons.dataSource = dataOutput
    }
}

private extension View {
    func addViewInStack() {
        let stack = UIStackView(frame: .zero)
        stack.axis = .horizontal
        
        let input = getInputLabel()
        let removeButton = getImageView()
        
        stack.addArrangedSubview(input)
        stack.addArrangedSubview(removeButton)
        stack.setCustomSpacing(25, after: input)
        
        self.stackInput.addArrangedSubview(stack)
    }
    
    func getInputLabel() -> UILabel {
        let view = UILabel()
        view.textAlignment = .right
        view.text = "891123"
        view.textColor = UIColor(named: "Text")
        view.font = UIFont(name: view.font.fontName, size: 35)
        view.numberOfLines = 1
        
        return view
    }
    
    func getImageView() -> UIImageView {
        let view = UIImageView(image: UIImage(named: "DeleteButton"))
        view.contentMode = .scaleAspectFit
        view.tintColor = UIColor(named: "DeleteButton")
        
        return view
    }
}

private extension View {
    func setup() {
        configure()
        configureConstraints()
    }
    
    func configure() {
        self.backgroundColor = UIColor(named: "BackgroundApp")
    }
    
    func configureConstraints() {
        self.titleApp.snp.makeConstraints({ make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(36)
            make.bottom.equalTo(self.result.snp.top).inset(-32.25)
        })
        
        self.result.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(self.stackInput.snp.top).inset(-39)
        }
        
        self.stackInput.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().inset(35)
        }
        
        self.buttons.snp.makeConstraints { make in
            make.top.equalTo(self.stackInput.snp.bottom).inset(-16)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(45)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
    }
}
