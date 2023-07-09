//
//  StringLiterals.swift
//  Umbba-iOS
//
//  Created by 최영린 on 2023/07/03.
//

import Foundation

enum I18N {
    
    enum Common {
        static let nextButtonTitle = "다음으로"
    }
    
    enum Onboarding {
        static let test = "test"
        static let inviteNavigationTitle = "초대코드입력"
        static let inviteTitle = "초대코드를\n입력해주세요."
        static let inviteBoldTitle = "초대코드"
        static let inviteTextFieldPlaceholder = "초대코드를 입력해주세요."
        static let inviteError = "*올바른 초대코드 형식이 아닙니다."
        static let timeNotice = "매일 밤 11시에\n타임머신을 보내줄게"
        static let subNotice = "초대자가 선택한 시간에 따라 알림을 보내드립니다."
        static let userInfoTitle = "반가워!\n너에 대행 알고 싶어!"
        static let nameInfo = "너의 이름이 뭐야?"
        static let namePlaceholder = "이름을 입력해주세요."
        static let nameError = "*올바른 형식이 아닙니다."
        static let genderInfo = "너의 성별을 알려줘!"
        static let male = "남자"
        static let female = "여자"
        static let birthInfo = "태어난 연도는 언제야?"
        static let birthPlaceholder = "태어난 연도를 입력해주세요."
        static let birthError = "*올바른 형식이 아닙니다."
    }
    
    struct Auth {
        static let loginTitle = "부모와 떠나는 시간 여행"
        static let appleButtonTitle = "애플로 로그인"
        static let kakaoButtonTitle = "카카오로 로그인"
        static let entryButtonTitle = "시작하기"
        static let dividingText = "--------------------- or ---------------------"
        static let inviteText = "초대 코드를 받으셨나요?"
        static let inviteButtonTitle = "초대코드 입력하기"
    }
    
    enum Archiving {
        static let navigationTitle = "리스트"
    }
    
}
