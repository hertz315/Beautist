//
//  BueatistViewModel.swift
//  Bueatist
//
//  Created by Hertz on 12/9/22.
//

import Foundation
import Combine

class BueatistViewModel: ObservableObject {
    
    // MARK: - 뷰모델 생성 init
    init() {
        
        print(#fileID, #function, #line, "⭐️뷰모델 생성")
        
//        강한 참조 조심
//        BeautistUserApi.loginAPI(userName: "honghaha1996", password: "@@Ghdrn315") { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//                // api 호출 성공시
//            case .success(let userLoginResponse):
//                print(userLoginResponse)
//                // api 호출 실패시
//            case .failure(let failure):
//                print(failure)
//                self.handleError(failure)
//            }
//        }
//
//        BeautistUserApi.userRetrievingAPI(objectId: "ndDZyHxTVc") { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let response):
//                print("VM / userRetrievingAPI /Success: \(response)")
//            case .failure(let failure):
//                print("VM / userRetrievingAPI /Falure: \(failure)")
//                self.handleError(failure)
//            }
//        }
//
//        BeautistUserApi.currentUserRetrievingAPI(sessionToken: "r:a046f937dbb0dbb002412a8b6fe86983") { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let response):
//                print("VM / currentUserRetrievingAPI /Success: \(response)")
//            case .failure(let failure):
//                print("VM / currentUserRetrievingAPI /Failure: \(failure)")
//                self.handleError(failure)
//            }
//        }
//
//        BeautistUserApi.signupAPI(userName: "honggoolee", email: "hongkaka999@gmail.com", password: "ghdrn315") { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let response):
//                print("VM / signupAPI /Success: \(response)")
//            case .failure(let failure):
//                print("VM/ signupAPI /Failure: \(failure)")
//                self.handleError(failure)
//            }
//        }
//
//        BeautistUserApi.editUserInformationAPI(sessionToken: "r:fe273180088454d9b8b69a495e41108d", objectId: "jSSAQpjmWC", userName: "콰지직쾅쾅", email: "hongkaka1996@gmail.com") { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let successResponse):
//                print("VM / eitUserInformationAPI /Success: \(successResponse)")
//            case .failure(let failure):
//                print("VM / eitUserInformationAPI /Failure: \(failure)")
//                self.handleError(failure)
//            }
//        }
//
//
//        BeautistUserApi.deleteUserAPI(sessionToken: "r:4cdf4ff84b9f2b956ac540889daa1ab9", objectId: "mf4jKAVsZf") { [weak self] responseResult in
//            guard let self = self else { return }
//            switch responseResult {
//
//            case .success(let successResult):
//                print("VM / deleteUserAPI /Success: \(successResult)")
//            case .failure(let failure):
//                print("VM / deleteUserAPI /Failure: \(failure)")
//                self.handleError(failure)
//            }
//        }
//
//        BeautistUserApi.verificationEmailRequestAPI(email: "hertz315@gmail.com") { [weak self] responseResult in
//            guard let self = self else { return }
//            switch responseResult {
//
//            case .success(let successResult):
//                print("VM / verificationEmailRequestAPI /Success: \(successResult)")
//            case .failure(let failure):
//                print("VM / verificationEmailRequestAPI /Failure: \(failure)")
//                self.handleError(failure)
//            }
//        }
//
//        BeautistUserApi.requestPasswordResetAPI(email: "hertz315@gmail.com") { [weak self] responseResult in
//            guard let self = self else { return }
//            switch responseResult {
//
//            case .success(let successResult):
//                print("VM / requestPasswordResetAPI /Success: \(successResult)")
//            case .failure(let failure):
//                print("VM / requestPasswordResetAPI /Failure: \(failure)")
//                self.handleError(failure)
//            }
//        }
//
//        // MARK: - 클로저 기반 api 연쇄 응답 처리
//        BeautistUserApi.signupUserAndLoginUserAPI(userName: "haha19961", email: "haha19961@gmail.com", password: "@@haha1996") { [weak self] responseResult in
//            guard let self = self else { return }
//
//            switch responseResult {
//            case .success(let data):
//                print("VM / signupUserAndLoginUserAPI /Success: \(data)")
//            case .failure(let failure):
//                print("VM / signupUserAndLoginUserAPI /Failure: \(failure)")
//                self.handleError(failure)
//            }
//
//
//        }
        
        
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
