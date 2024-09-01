//
//  Literal.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/15/24.
//

import Foundation

enum Literal {
    enum GuideMessage {
        static let nickName = "닉네임을 입력하세요"
        static let search = "해쉬태크를 검색해보세요."
        static let email = "이메일을 입력하세요."
        static let password = "비밀번호를 입력하세요."
        static let welcome = "환영합니다."
        static let welcomeMSG = "회원가입이 완료 되었습니다. 로그인해주세요!:)"
        static let signUp =  "회원가입"
        static let title = "제목"
        static let content = "내용"
        static let store = "스토어"
        static let photo = "사진 등록"
        static let titlePlaceholder = "방문하신 스토어에 대한 후기의 제목을 적어주세요."
        static let contentPlaceholder = "방문하신 스토어에 대한 후기의 내용을 적어주세요."
        static let storePlaceholder = "방문하신 스토어를 선택해 주세요."
        static let delete = "정말로 삭제하시겠습니까?"
        static let expiredToken = "토근이 만료되었습니다! 다시 로그인해주세요 :)"
        static let addComment = "댓글을 입력해보세요!"
        static let completePayingTitle = "결제완료"
        static let completePaying = "결제가 완료되었습니다. 감사합니다."
        static let paymentErrorTitle = "미승인"
        static let paymentError = "결제가 정상적으로 처리되지 않았습니다. 재시도 부탁드립니다."
        static let locationTitle = "위치 권한 필요"
        static let location = "현재 위치를 확인하려면 위치 권한이 필요합니다."
        static let logOut = "정말 로그아웃 하시겠습니까?"
    }
    
    enum ButtonName {
        static let save = "저장"
        static let cancel = "취소"
        static let login = "로그인"
        static let comform = "확인"
        static let goSignUp = "회원가입하러가기"
        static let signUp = "가입하기"
        static let upload = "등록하기"
        static let delete = "삭제"
        static let createPost = "글 작성하기"
        static let expiredToken = "토큰 만료"
        static let moveToConfigure = "설정으로 이동"
        static let moveToStore = "스토어 구경가기"
        static let order = "주문하기"
        static let location = " 위치보기"
        static let logOut = "로그아웃"
    }
    
    enum ViewTitle {
        static let favorite = "Favorite Shops"
        static let storeList = "CakeShop List"
        static let createPost = "업로드 하기"
        static let myPosting = "My Posting"
        static let paymentList = "구매 내역"
    }
}


