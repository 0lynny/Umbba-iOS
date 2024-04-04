//
//  ReloadAlertView.swift
//  Umbba-iOS
//
//  Created by 최영린 on 4/4/24.
//

import UIKit

import SnapKit

final class ReloadAlertView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: AlertDelegate?
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "질문을 변경하시겠어요?"
        label.font = .PretendardSemiBold(size: 20)
        label.textColor = .UmbbaBlack
        label.textAlignment = .center
        return label
    }()
    
    private lazy var exitButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.Common.icn_exit, for: .normal)
        button.tintColor = .UmbbaBlack
        return button
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .Gray400
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private let newLabel: UILabel = {
        let label = UILabel()
        label.text = "새로운 질문"
        label.font = .PretendardRegular(size: 12)
        label.textColor = .UmbbaBlack
        return label
    }()
    
    private let questionsLabel: UILabel = {
        let label = UILabel()
        label.text = "당신과 어머니의 꿈은 달라?"
        label.font = .PretendardSemiBold(size: 20)
        label.textColor = .UmbbaBlack
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "변경한 질문은 되돌릴 수 없어요"
        label.font = .PretendardRegular(size: 16)
        label.textColor = .UmbbaBlack
        return label
    }()
    
    private lazy var reloadButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .Primary500
        button.setTitle("질문 변경하기", for: .normal)
        button.titleLabel?.textColor = .White500
        button.titleLabel?.font = .PretendardSemiBold(size: 16)
        button.layer.cornerRadius = 24
        return button
    }()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setAddTarget()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

private extension ReloadAlertView {
    func setUI() {
        self.backgroundColor = .White500
        self.layer.cornerRadius = 16
    }
    
    func setAddTarget() {
        exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        reloadButton.addTarget(self, action: #selector(reloadButtonTapped), for: .touchUpInside)
    }
    
    func setLayout() {
        self.addSubviews(exitButton, titleLabel, backgroundView, subtitleLabel, reloadButton)
        backgroundView.addSubviews(newLabel, questionsLabel)
        
        exitButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.size.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.centerX.equalToSuperview()
        }
        
        backgroundView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.width.equalTo(SizeLiterals.Screen.screenWidth - 75)
            $0.height.equalTo(120)
            $0.centerX.equalToSuperview()
        }
        
        newLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
        
        questionsLabel.snp.makeConstraints {
            $0.top.equalTo(newLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(backgroundView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
        
        reloadButton.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(16)
            $0.width.equalTo(SizeLiterals.Screen.screenWidth - 74)
            $0.height.equalTo(48)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(32)
        }
    }
    
    // MARK: - @objc Functions
  
    @objc func exitButtonTapped() {
        delegate?.alertDismissTapped()
    }
    
    @objc func reloadButtonTapped() {
        delegate?.colorButtonTapped()
    }
    
}
