//
//  BeautistViewModel+Rx.swift
//  Bueatist
//
//  Created by Hertz on 12/10/22.
//

import Foundation
import RxCocoa
import RxSwift
import RxRelay

class BeautistViewModelRx: ObservableObject {
    
    var disposeBag = DisposeBag()
    
    // MARK: - 뷰모델 생성 init
    init() {
        
        print(#fileID, #function, #line, "⭐️Rx뷰모델 생성")
        
        BeautistUserApi.signupWithObservable(userName: "hertz1020", email: "hertz1020@gmail.com",password: "hertz1020")
        .observe(on: MainScheduler.instance) // 메인 쓰레드에서 값 받음
        .subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let sucessData):
                print("singupWithObservable: \(sucessData)")
            case .failure(let failure):
                self.handleError(failure)
            }
        })// 옵저버블 구독
        .disposed(by: disposeBag)
        
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
