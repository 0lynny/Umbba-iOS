//
//  WriteCancelAlertVIewController.swift
//  Umbba-iOS
//
//  Created by 최영린 on 2023/07/11.
//

import UIKit

enum AlertType {
    case writeCancelAlert
    case writeSaveAlert
    case withdrawalAlert
    case inviteAlert
    case disconnectAlert
    case updateAlert
    case reloadAlert
}

final class AlertViewController: UIViewController {
    
    // MARK: - Properties
    
    var alertType: AlertType?
    var okAction: (() -> Void)?
    
    // MARK: - UI Components
    
    private let writeCancelAlertView: WriteCancelAlertView = {
        let view = WriteCancelAlertView()
        return view
    }()
    
    private let writeSaveAlertView: WriteSaveAlertView = {
        let view = WriteSaveAlertView()
        return view
    }()
    
    private let withdrawalAlertView: WithdrawalAlertView = {
        let view = WithdrawalAlertView()
        return view
    }()
    
    private let inviteAlertView: InviteAlertView = {
        let view = InviteAlertView()
        return view
    }()
    
    private let disconnectAlertView: DisconnectAlertView = {
        let view = DisconnectAlertView()
        return view
    }()
    
    private let updateAlertView: UpdateAlertView = {
        let view = UpdateAlertView()
        return view
    }()
    
    private let reloadAlertView = ReloadAlertView()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        setUI()
        setAlertType()
        setLayout()
    }
}

// MARK: - Extensions

extension AlertViewController {
    
    func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.4)
    }
    
    func setAlertType() {
        switch alertType {
        case .writeCancelAlert:
            setAlertView(writeCancel: true, writeSave: false, withdrawal: false, invite: false, disconnect: false, update: false, reload: false)
        case .writeSaveAlert:
            setAlertView(writeCancel: false, writeSave: true, withdrawal: false, invite: false, disconnect: false, update: false, reload: false)
        case .withdrawalAlert:
            setAlertView(writeCancel: false, writeSave: false, withdrawal: true, invite: false, disconnect: false, update: false, reload: false)
        case .inviteAlert:
            setAlertView(writeCancel: false, writeSave: false, withdrawal: false, invite: true, disconnect: false, update: false, reload: false)
        case .disconnectAlert:
            setAlertView(writeCancel: false, writeSave: false, withdrawal: false, invite: false, disconnect: true, update: false, reload: false)
        case .updateAlert:
            setAlertView(writeCancel: false, writeSave: false, withdrawal: false, invite: false, disconnect: false, update: true, reload: false)
        case .reloadAlert:
            setAlertView(writeCancel: false, writeSave: false, withdrawal: false, invite: false, disconnect: false, update: false, reload: true)
        default:
            break
        }
    }
    
    func setAlertView(writeCancel: Bool, writeSave: Bool, withdrawal: Bool, invite: Bool, disconnect: Bool, update: Bool, reload: Bool) {
        writeCancelAlertView.isHidden = !writeCancel
        writeSaveAlertView.isHidden = !writeSave
        withdrawalAlertView.isHidden = !withdrawal
        inviteAlertView.isHidden = !invite
        disconnectAlertView.isHidden = !disconnect
        updateAlertView.isHidden = !update
        reloadAlertView.isHidden = !reload
    }
    
    func setLayout() {
        view.addSubviews(writeCancelAlertView,
                         writeSaveAlertView,
                         withdrawalAlertView,
                         inviteAlertView,
                         disconnectAlertView,
                         updateAlertView,
                         reloadAlertView)
        
        writeCancelAlertView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(SizeLiterals.Screen.popupWidth)
            $0.height.equalTo(SizeLiterals.Screen.popupWidth * 164 / 343)
        }
        
        writeSaveAlertView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(SizeLiterals.Screen.popupWidth)
        }
        
        withdrawalAlertView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(SizeLiterals.Screen.popupWidth)
            $0.height.equalTo(SizeLiterals.Screen.popupWidth * 164 / 343)
        }
        
        inviteAlertView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(SizeLiterals.Screen.popupWidth)
        }
        
        disconnectAlertView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(SizeLiterals.Screen.popupWidth)
            $0.height.equalTo(SizeLiterals.Screen.popupWidth * 472 / 343)
        }
        
        updateAlertView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(SizeLiterals.Screen.popupWidth)
        }
        
        reloadAlertView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(SizeLiterals.Screen.popupWidth)
        }
    }
    
    func setDelegate() {
        writeCancelAlertView.delegate = self
        writeSaveAlertView.delegate = self
        withdrawalAlertView.delegate = self
        inviteAlertView.delegate = self
        disconnectAlertView.delegate = self
        updateAlertView.delegate = self
        reloadAlertView.delegate = self
    }
    
    func emptyActions() {
        
    }
    
    func setAlertType(_ type: AlertType) {
        self.alertType = type
    }
    
    func setDataBind(wirtePopUp: WritePopUp) {
        if alertType == .writeSaveAlert {
            writeSaveAlertView.cafe24TitleLabel.text = wirtePopUp.section
            writeSaveAlertView.numberLabel.text = wirtePopUp.number
            writeSaveAlertView.themeLabel.text = wirtePopUp.topic
            writeSaveAlertView.questionLabel.text = wirtePopUp.question
            writeSaveAlertView.answerLabel.text = wirtePopUp.answer
        }
    }
    
    func setInviteDataBind(inviteCode: String, inviteUsername: String, installURL: String) {
        if alertType == .inviteAlert {
            inviteAlertView.inviteCode.text = inviteCode
        }
    }
    
    func setRerollDataBind(question: String) {
        if alertType == .reloadAlert {
            reloadAlertView.questionsLabel.text = question
        }
    }
}

// MARK: - AlertDelegate

extension AlertViewController: AlertDelegate {
    func copyButtonTapped(inviteCode: String) {
        UIPasteboard.general.string = inviteCode
        self.showToast(message: "초대코드가 복사되었습니다")
    }
    
    func colorButtonTapped() {
        dismiss(animated: false) {
            (self.okAction ?? self.emptyActions)()
        }
    }
    
    func alertDismissTapped() {
        dismiss(animated: true)
    }
}
