//
//  BeautistViewModel+Combine.swift
//  Bueatist
//
//  Created by Hertz on 12/11/22.
//

import Foundation
import Combine

class BeautistViewModelCombine: ObservableObject {
    
    // 찌꺼기 청소기⭐️
    var subscriptions = Set<AnyCancellable>()
    
    // MARK: - 뷰모델 생성 init
    init() {
        
        print(#fileID, #function, #line, "⭐️Rx뷰모델 생성")
        
        //        // MARK: - 회원가입
        //        BeautistUserApi.signupWithPublisher(userName: "hon315", email: "hon315@gmail.com", password: "hon315")
        //        // sink 로 이벤트 받기(구독) ⭐️
        //            .sink { [weak self] completion in
        //                guard let self = self else {return}
        //
        //                switch completion {
        //                case .finished:
        //                    print("VM : signupWithPublisher : 회원가입 : (완료)스트림끊킴❗️")
        //                case .failure(let failure):
        //                    self.handleError(failure)
        //                }
        //            } receiveValue: { response in
        //                print("VM / signupWithPublisher / \(response)")
        //            }
        //            .store(in: &subscriptions)
        
        
        
        //        // MARK: - 로그인
        //        BeautistUserApi.loginWithPublisher(userName: "hon315", password: "hon315")
        //            .sink { [weak self] completion in // 클로저이기 때문에 강한참조예방
        //
        //                guard let self = self else { return }
        //                switch completion {
        //                case .finished: // 완료되었을
        //                    print("VM : loginWithPublisher : 로그인 :(완료)스트림끊킴❗️")
        //                case .failure(let failure): // 실패되었을때
        //                    self.handleError(failure)
        //                }
        //
        //
        //            } receiveValue: { response in
        //                print("VM / loginWithPublisher / \(response)")
        //            }
        //            .store(in: &subscriptions)
        
        
        //        BeautistUserApi.signupUserAndLoginUserWithPublisher(userName: "m",
        //                                                            email: "m@gmail.com",
        //                                                            password: "m")
        //                    .sink { [weak self] completion in // 클로저이기 때문에 강한참조예방
        //                        guard let self = self else { return }
        //                        switch completion {
        //                        case .finished: // 완료되었을
        //                            print("VM : signupUserAndLoginUserWithPublisher : 회원가입 후 로그인 :(완료)스트림끊킴❗️")
        //                        case .failure(let failure): // 실패되었을때
        //                            self.handleError(failure)
        //                        }
        //
        //                    } receiveValue: { response in
        //                        print("VM / signupUserAndLoginUserWithPublisher / \(response)")
        //                    }
        //                    .store(in: &subscriptions)
        
        BeautistUserApi.deleteSelectedUsersWithPublisher(deleteUserTokenAndIdDictionary: [
            "r:53a90e1004490c8cf28902ed25a298ab" : "rV7sQsgLEj",
            "r:ba7548720b6664c2ef430028e117ae0c" : "ZE3eAP1hC8",
            "r:0a2a66b54a78b2f56844326f0cc1e2cc" : "Dh5MlegJhR"
        ])
        .sink { [weak self] completion in // 클로저이기 때문에 강한참조예방
            guard let self = self else { return }
            switch completion {
            case .finished: // 완료되었을
                print("VM : deleteSelectedUsersWithPublisher : 동시 회원 삭제 :(완료)스트림끊킴❗️")
            case .failure(let failure): // 실패되었을때
                self.handleError(failure)
            }
            
        } receiveValue: { response in
            print("VM / deleteSelectedUsersWithPublisher / \(response)")
        }
        .store(in: &subscriptions)
        
        
    }// init종료지점
    
    
    
    
    // MARK: - API 에러처리
    /// API 에러처리
    /// - Parameter err: API 에러
    fileprivate func handleError(_ err: Error) {
        
        if err is BeautistUserApi.ApiError {
            let apiError = err as! BeautistUserApi.ApiError
            
            print("handleError: err \(apiError.info)")
            
            switch apiError {
            case .passingError:
                print("파싱에러")
            case .unAuthorized:
                print("사용자 인증안됨")
            default:
                print("그밖에 에러")
            }
        }
    }
    
}
