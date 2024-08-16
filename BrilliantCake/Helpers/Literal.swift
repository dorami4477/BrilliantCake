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
        static let search = "케이크를 검색해보세요."
        static let writeSth = "검색어를 먼저 입력하세요"
        static let noResult = "검색 결과가 없습니다"
        static let noFavorite = "저장한 사진이 없습니다❕\n좋아하는 사진을 모아보세요❗️"
        static let addFavorite = "좋아하는 사진이 추가되었습니다❕"
        static let deleteFavorite = "저장된 사진이 삭제되었습니다❗️"
        static let networkError = "네트워크에 문제가 있습니다❗️ \n잠시 후 다시 시도해주세요."
        static let usableNickName = "사용할 수 있는 닉네임이에요."
        static let withdrawTitle = "탈퇴하기"
        static let withdrawMSG = "탈퇴하면 모든 정보가 삭제 됩니다. 정말로 삭제 하시겠습니까?"
    }
    
    enum ButtonName {
        static let start = "시작하기"
        static let withdrawal = "회원탈퇴"
        static let withdraw = "탈퇴"
        static let completion = "완료"
        static let save = "저장"
        static let cancel = "취소"
    }
    
}


