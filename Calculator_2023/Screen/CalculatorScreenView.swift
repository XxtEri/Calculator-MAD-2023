//
//  View.swift
//  Calculator_2023
//
//  Created by Елена on 19.02.2023.
//

import UIKit
import SnapKit

class CalculatorScreenView: UIView {
    
    // MARK: - Private properties
    
    private enum Metrics {
        static let titleAppSizeFont: CGFloat = 28
        static let resultSizeFont: CGFloat = 57
        static let inputSizeFont: CGFloat = 35
        
        static let maxNumberOfLines = 1
        static let spacingStackInput: CGFloat = 25
        static let horizontalInsetScreen: CGFloat = 24
        
        static let titleAppInsetTop: CGFloat = 36
        static let titleAppInsetBottom: CGFloat = -32.25
        
        static let resultHeight: CGFloat = 75
        static let resultInsetBottom: CGFloat = -30
        
        static let stackInputHeight: CGFloat = 48
        
        static let lineHeight: CGFloat = 1
        
        static let buttonsInsetTop: CGFloat = -16
        static let buttonsInsetBottom: CGFloat = 45
    }
    
    private lazy var titleApp: UILabel =  {
        let view = UILabel()
        view.text = "Calculator"
        view.textColor = UIColor(named: "TitleApp")
        view.textAlignment = .left
        view.font = UIFont(name: TitleFonts.googlesansBold, size: Metrics.titleAppSizeFont)

        return view
    }()
    
    private lazy var result: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.textColor = UIColor(named: "Answer")
        view.font = UIFont(name: TitleFonts.googlesansMedium, size: Metrics.resultSizeFont)
        view.numberOfLines = Metrics.maxNumberOfLines
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.2
        
        return view
    }()
    
    private lazy var inputBlockView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private lazy var input: UILabel = {
        let view = UILabel()
        
        view.textColor = UIColor(named: "Text")
        view.font = UIFont(name: TitleFonts.googlesansRegular, size: Metrics.inputSizeFont)
        view.textAlignment = .right
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.2
        view.numberOfLines = Metrics.maxNumberOfLines
        view.backgroundColor = .clear
        
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
        let view = UIStackView()
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
        view.isScrollEnabled = false
        view.contentMode = .center
        
        view.register(CalculatorScreenCollectionViewCell.self, forCellWithReuseIdentifier: CalculatorScreenCollectionViewCell.reuseIdentifier)
        
        return view
    }()
    
    
    // MARK: - Public properties
    
    var didSelectDeleteButtonHandler: (() -> Void)?
    
    
    // MARK: - Methods

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleApp)
        self.addSubview(inputBlockView)
        
        inputBlockView.addSubview(result)
        inputBlockView.addSubview(input)
        inputBlockView.addSubview(delete)
        inputBlockView.addSubview(line)
        
        self.addSubview(buttons)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private extension properties

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
            make.horizontalEdges.equalToSuperview().inset(Metrics.horizontalInsetScreen)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(Metrics.titleAppInsetTop)
            make.bottom.equalTo(result.snp.top).inset(Metrics.titleAppInsetBottom)
        }
        
        self.inputBlockView.snp.makeConstraints { make in
            make.top.equalTo(self.titleApp.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(25)
            make.height.equalToSuperview().multipliedBy(0.29)
        }
        
        self.delete.snp.makeConstraints { make in
            make.bottom.equalToSuperview().multipliedBy(0.85)
            make.trailing.equalToSuperview().inset(10)
        }
        
        self.result.snp.makeConstraints { make in
            make.bottom.equalTo(self.delete.snp.top).multipliedBy(0.8)
            make.horizontalEdges.equalToSuperview()
        }
        
        self.input.snp.makeConstraints { make in
            make.top.equalTo(self.result.snp.bottom)
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(50)
            make.bottom.equalTo(self.line.snp.top)
        }

        self.line.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.buttons.snp.makeConstraints { make in
            make.top.equalTo(self.inputBlockView.snp.bottom).inset(Metrics.buttonsInsetTop)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(Metrics.buttonsInsetBottom)
            make.horizontalEdges.equalToSuperview().inset(Metrics.horizontalInsetScreen)
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

// MARK: - Public extension properties

extension CalculatorScreenView {
    func setupCollectionView(delegate: UICollectionViewDelegate, dataOutput: UICollectionViewDataSource) {
        buttons.delegate = delegate
        buttons.dataSource = dataOutput
    }
    
    func setInputExpression(_ expression: String) {
        input.text = expression
    }
    
    func setResultNumberExpression(_ expression: String) {
        result.text = expression
        
        if expression == "Error" {
            result.textColor = UIColor(named: "Error")
        }
    }
    
    func clearData() {
        input.text = String()
        result.text = String()
    }
}
