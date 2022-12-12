//
//  BeautistViewModel+Combine.swift
//  Bueatist
//
//  Created by Hertz on 12/11/22.
//

import Foundation
import Combine

final class BeautistViewModel: ObservableObject {
    
    // MARK: - 📌
    @Published var userName: String = ""
    @Published var passWord: String = ""
    @Published var sesstionToken: String = ""
    @Published var objectId: String = ""
    
    
    @Published var errorMessage: String = ""
    
    // MARK: - 비밀번호 퍼블리셔
    // 비밀 번호 퍼블리셔
    @Published var checkPassWord1: String = ""
    @Published var checkPassWord2: String = ""
    // 비밀번호 + 비밀번호 확인 일치여부
    @Published var passwordAndPasswordCheckSame: Bool = false
    // 비밀번호 + 비밀번호 확인 글자수 6~12 사이 여부
    @Published var passwordAndPasswordCheckCountValid: Bool = false
    // 비밀번호 유효성 최종 학인 여부
    @Published var passwordValidCheck: Bool = true
    
    
    // MARK: - 이메일 퍼블리셔
    @Published var email: String = ""
    @Published var emailValid: Bool = false
    // 이메일에 @이 들어있는지 확인 여부
    @Published var emailValidCheck: Bool = false
    
    
    // MARK: - 회원가입 준비 완료
    @Published var signupReadyComplete: Bool = false
    
    
    // 찌꺼기 청소기⭐️
    var subscriptions = Set<AnyCancellable>()
    
    // MARK: - 회원가입 ⭐️
    func signup() {
        BeautistUserApi.signupWithPublisher(userName: userName, email: email, password: passWord)
            .sink { completion in
                switch completion {
                case .finished:
                    print("signup : 완료후 스트림 끊킴 ⭐️")
                case .failure(let failure):
                    self.handleError(failure)
                }
            } receiveValue: { response in
                print("\(response)⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️")
            }
            .store(in: &subscriptions)
    }
    
    // 비밀번호 입력한 것이 같은지
    // 비밀번호 6자리 이상 ~ 12 자리 이하
    // MARK: - 비밀번호 유효성 체크
    func passwordTextFieldValidCheck() {
        
        // 비밀번호 입력한 것이 같은지
        Publishers.CombineLatest($checkPassWord1, $checkPassWord2)
            .map { (password1, password2) in
                if password1 != password2 {
                    return false
                }
                self.passWord += password2
                
                return true
            }
            .assign(to: \.self.passwordAndPasswordCheckSame, on: self)
            .store(in: &subscriptions)
        
        
        
        // 비밀번호 6자리 이상 ~ 12 자리 이하
        Publishers.CombineLatest($checkPassWord1, $checkPassWord2)
            .map { (password1, password2) in
                if (6...12).contains(password1.count) && (6...12).contains(password2.count) {
                    return true
                } else {
                    return false
                }
            }
            .assign(to: \.self.passwordAndPasswordCheckCountValid, on: self)
            .store(in: &subscriptions)
        
        // 여러가지 상태 스트림 합치기
        Publishers.CombineLatest($passwordAndPasswordCheckSame, $passwordAndPasswordCheckCountValid)
            .map { (checkSame, checkCountValid) in
                if (checkSame == true && checkCountValid == true) {
                    return true
                } else {
                    return false
                }
            }
            .assign(to: \.self.passwordValidCheck, on: self)
            .store(in: &subscriptions)
    }
    
    // MARK: - 이메일 유효성 체크
    func emailAdressValidCheck() {
        $email
            .map { email in
                let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
                
                return emailPredicate.evaluate(with: email)
            }
            .sink { bool in
                print("\(bool)⭐️")
                self.emailValidCheck = bool
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - 시작하기 버튼 활성화
    func signupComplete() {
        Publishers.CombineLatest($passwordValidCheck, $emailValidCheck)
            .map { (passwordCheck, emailCheck) in
                if (passwordCheck == true && emailCheck == true) {
                    return true
                } else {
                    return false
                }
            }
            .assign(to: \.self.signupReadyComplete, on: self)
            .store(in: &subscriptions)
    }
    
    
    
    // MARK: - 뷰모델 생성 init
    init() {
        // MARK: - 비밀번호 유효성
        self.passwordTextFieldValidCheck()
        // MARK: - 이메일 유효성
        self.emailAdressValidCheck()
        // MARK: - 모든 준비 완료 여부체크
        self.signupComplete()
      
        
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
        
        //        BeautistUserApi.deleteSelectedUsersWithPublisher(deleteUserTokenAndIdDictionary: [
        //            "r:53a90e1004490c8cf28902ed25a298ab" : "rV7sQsgLEj",
        //            "r:ba7548720b6664c2ef430028e117ae0c" : "ZE3eAP1hC8",
        //            "r:0a2a66b54a78b2f56844326f0cc1e2cc" : "Dh5MlegJhR"
        //        ])
        //        .sink { [weak self] completion in // 클로저이기 때문에 강한참조예방
        //            guard let self = self else { return }
        //            switch completion {
        //            case .finished: // 완료되었을
        //                print("VM : deleteSelectedUsersWithPublisher : 동시 회원 삭제 :(완료)스트림끊킴❗️")
        //            case .failure(let failure): // 실패되었을때
        //                self.handleError(failure)
        //            }
        //
        //        } receiveValue: { response in
        //            print("VM / deleteSelectedUsersWithPublisher / \(response)")
        //        }
        //        .store(in: &subscriptions)
        
        
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
