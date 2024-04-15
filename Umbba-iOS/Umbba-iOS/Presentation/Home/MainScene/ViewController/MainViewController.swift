//
//  MainViewController.swift
//  Umbba-iOS
//
//  Created by 고아라 on 2023/07/14.
//

import UIKit

import KakaoSDKCommon
import KakaoSDKTemplate
import KakaoSDKShare
import FirebaseDynamicLinks
import RxGesture
import RxSwift

protocol PopUpDelegate: AnyObject {
    func showInvitePopUP(inviteCode: String)
    func showDisconnectPopUP()
}

final class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    var isShow = false
    private let disposeBag = DisposeBag()
    
    private var caseEntity: CaseEntity? {
        didSet {
            fetchData()
        }
    }
    
    private var mainEntity: MainEntity? {
        didSet {
            fetchData()
        }
    }
    
    private var firstEntity: FirstEntity? {
        didSet {
            fetchData()
        }
    }
    
    var inviteCode: String = ""
    var inviteUserName: String = ""
    
    weak var delegate: PopUpDelegate?
    
    // MARK: - UI Components
    
    private let mainView = MainView()
    
    override func loadView() {
        super.loadView()
        
        self.view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getMainAPI()
        getCaseAPI()
        patchFirstAPI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        setGesture()
        getCaseAPI()
        getMainAPI()
        patchFirstAPI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

private extension MainViewController {
    
    func setDelegate() {
        mainView.mainDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(reloadView), name: NSNotification.Name(rawValue: "patchRestart"), object: nil)
    }
    
    func setGesture() {
        self.mainView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                NotificationCenter.default.post(name: Notification.Name("hideTutorial"), object: nil)
                self.mainView.tutorialBackground.isHidden = true
                self.mainView.tutorialImage.isHidden = true
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    func reloadView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.getMainAPI()
        }
    }
    
    func fetchData() {
        guard let mainEntity = mainEntity else { return }
        mainView.setDataBind(model: mainEntity)
        if SizeLiterals.Screen.deviceRatio > 0.5 {
            mainView.setSEImageBind(model: mainEntity)
        } else {
            mainView.setImageBind(model: mainEntity)
        }
        
        guard let homeCase = caseEntity?.responseCase else { return }
        guard let isEntry = firstEntity?.isFirstEntry else { return }
        if isEntry {
            if homeCase == 2 {
                mainView.tutorialLabel.text = "상대를 초대하고 답장을 받아보자"
            } else if homeCase == 4 {
                mainView.tutorialLabel.text = "클릭하여 오늘의 질문을 확인하자"
            }
            NotificationCenter.default.post(name: Notification.Name("showTutorial"), object: nil)
            mainView.tutorialBackground.isHidden = false
            mainView.tutorialImage.isHidden = false
        } else {
            NotificationCenter.default.post(name: Notification.Name("hideTutorial"), object: nil)
            mainView.tutorialBackground.isHidden = true
            mainView.tutorialImage.isHidden = true
        }
    }
    
    func setNextController() {
        switch caseEntity?.responseCase {
        case 1:
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let keyWindow = windowScene.windows.first else {
                return
            }
            let answerDetailController = AnswerDetailViewController()
            answerDetailController.isHome = true
            answerDetailController.isShowTutorial = false
            keyWindow.rootViewController = UINavigationController(rootViewController: answerDetailController)
            if let navigationController = keyWindow.rootViewController as? UINavigationController {
                navigationController.isNavigationBarHidden = true
            }
        case 2:
            guard let inviteCode = caseEntity?.inviteCode  else { return }
            guard let inviteUsername = caseEntity?.inviteUsername else { return }
            guard let installURL = caseEntity?.installURL else { return }
            NotificationCenter.default.post(name: Notification.Name("share"), object: nil, userInfo: ["inviteCode": inviteCode, "inviteUserName": inviteUsername, "installURL": installURL])
        case 3:
            NotificationCenter.default.post(name: Notification.Name("disconnect"), object: nil, userInfo: nil)
        case 4:
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let keyWindow = windowScene.windows.first else {
                return
            }
            let answerDetailController = AnswerDetailViewController()
            answerDetailController.isHome = true
            answerDetailController.isShowTutorial = true
            keyWindow.rootViewController = UINavigationController(rootViewController: answerDetailController)
            if let navigationController = keyWindow.rootViewController as? UINavigationController {
                navigationController.isNavigationBarHidden = true
            }
        default:
            break
        }
    }
}

extension MainViewController: MainDelegate {
    func questionButtonTapped() {
        getCaseAPI()
        setNextController()
    }
}

// MARK: - Network

private extension MainViewController {
    func getMainAPI() {
        NotificationCenter.default.post(name: Notification.Name("show"), object: nil, userInfo: nil)
        HomeService.shared.getHomeAPI { networkResult in
            switch networkResult {
            case .success(let data):
                if let data = data as? GenericResponse<MainEntity> {
                    NotificationCenter.default.post(name: Notification.Name("hide"), object: nil, userInfo: nil)
                    if let mainData = data.data {
                        self.mainEntity = mainData
                        if mainData.index == -1 && !self.isShow {
                            self.isShow = true
                            self.getEndingPage()
                        }
                    }
                }
            case .requestErr, .serverErr:
                self.makeAlert(title: "오류가 발생했습니다", message: "다시 시도해주세요")
            default:
                break
            }
        }
    }
    
    func getCaseAPI() {
        HomeService.shared.getCaseAPI { networkResult in
            switch networkResult {
            case .success(let data):
                if let data = data as? GenericResponse<CaseEntity> {
                    if let caseData = data.data {
                        self.caseEntity = caseData
                        self.inviteUserName = caseData.inviteUsername ?? ""
                        self.inviteCode = caseData.inviteCode ?? ""
                    }
                }
            case .requestErr, .serverErr:
                self.makeAlert(title: "오류가 발생했습니다", message: "다시 시도해주세요")
            default:
                break
            }
        }
    }
    
    func patchFirstAPI() {
        HomeService.shared.patchFirstAPI { networkResult in
            switch networkResult {
            case .success(let data):
                if let data = data as? GenericResponse<FirstEntity> {
                    if let firstData = data.data {
                        self.firstEntity = firstData
                    }
                }
            case .requestErr, .serverErr:
                self.makeAlert(title: "오류가 발생했습니다", message: "다시 시도해주세요")
            default:
                break
            }
        }
    }
}

extension MainViewController {
    func getEndingPage() {
        let nav = EndingViewController()
        nav.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nav, animated: false)
    }
}
