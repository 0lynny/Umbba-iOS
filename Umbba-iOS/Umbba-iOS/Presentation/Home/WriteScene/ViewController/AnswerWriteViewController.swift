//
//  AnswerWriteViewController.swift
//  Umbba-iOS
//
//  Created by 최영린 on 2023/07/10.
//

import UIKit

final class AnswerWriteViewController: UIViewController {
    
    private let answerWriteView = AnswerWriteView()
    
    override func loadView() {
        super.loadView()
        
        view = answerWriteView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationUI()
    }
}

// MARK: - Methods

extension AnswerWriteViewController {
    func setNavigationUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
        
    @objc func backButtonTapped() {
        print("눌림요")
    }
}
