//
//  BeautistViewModel+Combine.swift
//  Bueatist
//
//  Created by Hertz on 12/11/22.
//

import Foundation
import Combine
import UIKit
import SwiftUI

final class BeautistViewModel: ObservableObject {
    
    // MARK: - 📌 필드 입력
    @Published var userName: String = ""
    @Published var sesstionToken: String = ""
    @Published var objectId: String = ""
    @Published var thumbNailPhotoString: String = ""
    
    // MARK: - 👀비밀번호 퍼블리셔
    @Published var passWord: String = ""
    // 비밀 번호 퍼블리셔
    @Published var checkPassWord1: String = ""
    @Published var checkPassWord2: String = ""
    // 비밀번호 + 비밀번호 확인 일치여부
    @Published var passwordAndPasswordCheckSame: Bool = false
    // 비밀번호 + 비밀번호 확인 글자수 6~12 사이 여부
    @Published var passwordAndPasswordCheckCountValid: Bool = false
    // 비밀번호 유효성 최종 학인 여부
    @Published var passwordValidCheck: Bool = true
    
    
    // MARK: - 👀프로필 이미지 등록
    @Published var profileImagePickerPresented = false
    @Published var selectedProfileImage: UIImage?
    @Published var profileImage: Image?
    @Published var profileImageString: String = ""
    
    
    // MARK: - 👀썸네일 이미지
    @Published var thumbNailImagePickerPresented = false
    @Published var selectedThumbNailImage: UIImage?
    @Published var thumbNailImage: Image?
    @Published var thumbNailImageString: String = ""
    
    
    
    // MARK: - 📧이메일 퍼블리셔
    @Published var email: String = ""
    @Published var emailValid: Bool = false
    @Published var emailValidCheck: Bool = false
    
    
    // MARK: - ✅회원가입 준비 완료
    @Published var signupReadyComplete: Bool = false
    
    
    // MARK: - 찌거기 청소기⭐️
    var subscriptions = Set<AnyCancellable>()
    
    
    // MARK: - 이미지 로드
    func loadImage() {
        $selectedProfileImage
            .compactMap{ $0 }
            .map({ return Image(uiImage: $0) })
            .assign(to: \.self.profileImage, on: self)
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
    
    // MARK: - 회원가입 처리
    func signUp() {
        BeautistUserApi.signUpWithPublisher(userName: userName, email: email, passWord: passWord, profileImageString: profileImageString)
            .sink { [weak self] completion in
                guard let self = self else {return}
                
                switch completion {
                case .finished:
                    print("VM : signupWithPublisher : 회원가입 : (완료)스트림끊킴❗️")
                case .failure(let failure):
                    self.handleError(failure)
                }
            } receiveValue: { response in
                print("VM / signupWithPublisher / \(response)")
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - 회원가입 한후 로그인 처리 ⭐️
    func signUpAndLogIn() {
        BeautistUserApi.signUpAndLogInWithPublisher(userName: userName,
                                                    email: email,
                                                    passWord: passWord,
                                                    profileImageString: profileImageString)
        .sink { [weak self] completion in
            guard let self = self else { return }
            switch completion {
            case .finished:
                print("❗️회원가입 한후 로그인 스트림 끊킴")
            case .failure(let failure):
                self.handleError(failure)
            }
        } receiveValue: { sucessResponse in
            print("vm : signUpAndLogIn : \(sucessResponse)")
        }
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
