//
//  AnswerDetailViewController.swift
//  Umbba-iOS
//
//  Created by 남유진 on 2023/07/13.
//

import UIKit

final class AnswerDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var isHome: Bool = true
    
    private var todayEntity: TodayEntity? {
        didSet {
            fetchTodayData()
        }
    }
    
    private var detailEntity: DetailEntity? {
        didSet {
            fetchDetailData()
        }
    }
    
    var questionId: Int = -1
    
    // MARK: - UI Components
    
    private let answerDetailView = AnswerDetailView()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        view = answerDetailView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        routeAPI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        routeAPI()
        setDelegate()
    }
}

// MARK: - Extensions

extension AnswerDetailViewController {
    
    func setDelegate() {
        answerDetailView.delegate = self
        answerDetailView.nextDelegate = self
        answerDetailView.homeDelegate = self
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func routeAPI() {
        if isHome {
            getTodayAPI()
        } else {
            getArchivingDetailAPI(row: questionId)
        }
    }
    
    func fetchTodayData() {
        guard let todayEntity = todayEntity else { return }
        guard let isMyAnswer = todayEntity.isMyAnswer else { return }
        guard let isOpponentAnswer = todayEntity.isOpponentAnswer else { return }
        answerDetailView.setTodayDataBind(model: todayEntity)
        if isMyAnswer {
            answerDetailView.partnerQuestLabel.blurRadius = 0
            answerDetailView.myAnswerView.backgroundColor = .Gray300
            answerDetailView.myAnswerView.layer.borderColor = UIColor.Gray400.cgColor
            if isOpponentAnswer {
                answerDetailView.partnerAnswerContent.blurRadius = 0
            }
        }
        if isMyAnswer || isOpponentAnswer {
            self.answerDetailView.navigationBarView.rightButton.isHidden = true
        }
    }
    
    func fetchDetailData() {
        guard let detailEntity = detailEntity else { return }
        answerDetailView.setDetailDataBind(model: detailEntity)
    }
    
}

extension AnswerDetailViewController: NavigationBarDelegate {
    @objc
    func backButtonTapped() {
        if isHome {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let keyWindow = windowScene.windows.first else {
                return
            }
            keyWindow.rootViewController = TabBarController()
        } else {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    func completeButtonTapped() {
        guard let index = todayEntity?.index else { return }
        guard let isRerollTime = todayEntity?.isRerollTime else { return }
        if index > 7 {
            if !isRerollTime {
                self.showToast(message: "변경한 질문은 되돌릴 수 없어요")
            } else {
                getRerollCheckAPI()
            }
        } else {
            self.answerDetailView.navigationBarView.rightButton.isHidden = true
        }
        
    }
}

extension AnswerDetailViewController: UIGestureRecognizerDelegate {
    func setGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        view.addGestureRecognizer(tapGesture)
    }
}

extension AnswerDetailViewController: NextButtonDelegate {
    func nextButtonTapped() {
        guard let todayEntity = todayEntity else { return }
        TodayData.shared.section = todayEntity.section ?? ""
        TodayData.shared.index = todayEntity.index ?? 0
        TodayData.shared.topic = todayEntity.topic ?? ""
        TodayData.shared.myQuestion = todayEntity.myQuestion ?? ""
        self.navigationController?.pushViewController(AnswerWriteViewController(), animated: true)
    }
}

extension AnswerDetailViewController: HomeButtonDelegate {
    func homeButtonTapped() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let keyWindow = windowScene.windows.first else {
            return
        }
        keyWindow.rootViewController = TabBarController()
    }
}

// MARK: - Network

extension AnswerDetailViewController {
    func getTodayAPI() {
        LoadingView.shared.show(self.view)
        HomeService.shared.getTodayAPI { networkResult in
            switch networkResult {
            case .success(let data):
                if let data = data as? GenericResponse<TodayEntity> {
                    LoadingView.shared.hide {
                    }
                    if let todayData = data.data {
                        self.todayEntity = todayData
                    }
                }
            case .requestErr, .serverErr:
                self.makeAlert(title: "오류가 발생했습니다", message: "다시 시도해주세요")
            case .noneQnAErr:
                self.showToast(message: "남은 질문이 존재하지 않아요")
            default:
                break
            }
        }
    }
    
    func getArchivingDetailAPI(row: Int) {
        LoadingView.shared.show(self.view)
        ArchivingListService.shared.getArchivingDetailAPI(qnaId: row) { networkResult in
            switch networkResult {
            case .success(let data):
                if let data = data as? GenericResponse<DetailEntity> {
                    LoadingView.shared.hide {
                    }
                    if let detailData = data.data {
                        self.detailEntity = detailData
                    }
                }
            case .requestErr, .serverErr:
                self.makeAlert(title: "오류가 발생했습니다", message: "다시 시도해주세요")
            default:
                break
            }
        }
    }
    
    func getRerollCheckAPI() {
        HomeService.shared.getRerollCheckAPI { networkResult in
            switch networkResult {
            case .success(let data):
                if let data = data as? GenericResponse<CheckEntity> {
                    if let checkData = data.data {
                        self.makeAlert(question: checkData.newQuestion, alertType: .reloadAlert) {
                            self.patchRerollChangeAPI(questionId: checkData.questionID)
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
    
    func patchRerollChangeAPI(questionId: Int) {
        HomeService.shared.patchRerollChangeAPI(questionId: questionId) { networkResult in
            switch networkResult {
            case .success:
                self.getTodayAPI()
            case .requestErr:
                // 수정 필요
                self.showToast(message: "질문 새로 고침은 1일 1회만 가능합니다")
            case .serverErr:
                self.makeAlert(title: "오류가 발생했습니다", message: "다시 시도해주세요")
            default:
                break
            }
        }
    }
}
