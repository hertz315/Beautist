//
//  BueatistAPI.swift
//  Bueatist
//
//  Created by Hertz on 12/9/22.
//

import Foundation
import RxSwift
import RxCocoa

extension BeautistUserApi {
    

    
    /// - Parameters:
    ///   - userName: 유저닉네임
    ///   - email: 유저이메일
    ///   - password: 유저패스워드
    ///   - completion: 응답타입 클로저 터트리기
    // MARK: - 회원가입 Api - "POST"
    static func signupWithObservable(userName: String, email: String, password: String) -> Observable<Result<UserResponse, ApiError>> {
        
        let requestParams: [String:Any] = [
            "username":userName,
            "email":email,
            "password":password
        ]
        
        // MARK: - URLRequest를 만든다
        let urlString: String = baseURL + "users"
        
        guard let url: URL = URL(string: urlString) else {
            return Observable.just(.failure(.notAllowUrl))
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("WCONfRfv8aio2yPtqOYWcWZKMltIj9IkkkCkFeyl", forHTTPHeaderField: "X-Parse-Application-Id")
        urlRequest.addValue("9EjhBUWG4G9aql4Q2GlTr9NqriQxbpaR2XCYQTSg", forHTTPHeaderField: "X-Parse-REST-API-Key")
        urlRequest.addValue("1", forHTTPHeaderField: "X-Parse-Revocable-Session")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        
        do {
            // 딕셔너리를 JSONData 로 만들기
            let jsonData: Data = try JSONSerialization.data(withJSONObject: requestParams, options: [.prettyPrinted])
            // JSON형태로 만든 데이터를 httpBody에 넣기
            urlRequest.httpBody = jsonData
        } catch {
            // JSON serialization failed
            return Observable.just(.failure(.jsonEncodingError))
        }
        
        // MARK: - URLSession으로 API를 호출한다
        // MARK: - API호출에 대한 응답을 받는다
        // 만든URLRequest를 가지고 데이터 추출
        return URLSession.shared.rx.response(request: urlRequest)
            .map({ (response: HTTPURLResponse, data: Data) -> Result<UserResponse, ApiError> in
                
                // 에러가 있다면 에러 출력
                // httpResponse 없다며 에러
//                guard let httpResponse: HTTPURLResponse = response as? HTTPURLResponse else {
//                    print("bad status code")
//                    return .failure(ApiError.unKnown(nil))
//                }
                
                // httpResponse 상태코드가 401 이라면 에러
                switch response.statusCode {
                case 401:
                    return .failure(.unAuthorized)
                default:
                    print("default: \(response.statusCode)⭐️")
                }
                
                if !(200...299).contains(response.statusCode) {
                    return .failure(ApiError.badStatus(code: response.statusCode))
                }
                
                // JSON -> Struct 디코딩 하고 있는작업 == 데이터 파싱⭐️
                // MARK: - 데이터파싱
                do {
                    let response = try JSONDecoder().decode(UserResponse.self, from: data)
                    return Result.success(response)
                    
                    // 파싱에 실패하면 에러
                } catch {
                    return Result.failure(.passingError)
                }
                
            })
        
    }
    
    /// - Parameters:
    ///   - userName: 유저이름
    ///   - password: 유저패스워드
    ///   - completion: 응답타입 클로저 터트리기
    // MARK: - 로그인하기 API - "GET"
    static func loginWithObservable(userName: String, password: String, completion: @escaping ((Result<UserResponse, ApiError>) -> Void)) {
        
        // MARK: - URLRequest를 만든다
        // https://parseapi.back4app.com/login?username=hertz315&password=%40%40Ghdrn315
        var urlComponents = URLComponents(string: baseURL + "login?")!
        urlComponents.queryItems = [
            URLQueryItem(name: "username", value: userName),
            URLQueryItem(name: "password", value: password)
        ]
        
        guard let url = urlComponents.url else {
            return completion(.failure(.notAllowUrl))
        }
        
        
        // URLRequest 생성
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("WCONfRfv8aio2yPtqOYWcWZKMltIj9IkkkCkFeyl", forHTTPHeaderField: "X-Parse-Application-Id")
        urlRequest.addValue("9EjhBUWG4G9aql4Q2GlTr9NqriQxbpaR2XCYQTSg", forHTTPHeaderField: "X-Parse-REST-API-Key")
        urlRequest.addValue("1", forHTTPHeaderField: "X-Parse-Revocable-Session")
        
        // MARK: - URLSession으로 API를 호출한다
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            
            // 에러가 있다면 에러 출력
            // httpResponse 없다며 에러
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                return completion(.failure(ApiError.unKnown(error)))
            }
            
            // httpResponse 상태코드가 401 이라면 에러
            switch httpResponse.statusCode {
            case 401:
                return completion(.failure(.unAuthorized))
            default:
                print("default: \(httpResponse.statusCode)⭐️")
            }
            
            // httpResponse 상태코드가 200 ~ 299 사이가 아니라면 에러
            if !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(.badStatus(code: httpResponse.statusCode)))
            }
            
            // 데이터 언래핑
            if let jsonData = data {
                // JSON -> Struct 디코딩 하고 있는작업 == 데이터 파싱⭐️
                do {
                    let response = try JSONDecoder().decode(UserResponse.self, from: jsonData)
                    let userLoginResponse = response
                    completion(.success(userLoginResponse))
                    
                    // 파싱에 실패하면 에러
                } catch {
                    completion(.failure(.passingError))
                }
            }
            
        }.resume()
        
        // 3. API 호출에대한 응답값을 받는다
        
        
    }
    
    /// - Parameters:
    ///   - objectId: 유저객체ID
    ///   - completion: 응답타입 클로저 터트리기
    // MARK: - 특정 유저 검색하기 API "GET"
    static func userRetrievingWithObservable(objectId: String, completion: @escaping ((Result<UserResponse, ApiError>) -> Void)) {
        
        // MARK: - URLRequest를 만든다
        // https://parseapi.back4app.com/users/ndDZyHxTVc
        // baseURL = https://parseapi.back4app.com/
        let urlString = baseURL + "users/" + objectId
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(.notAllowUrl))
        }
        
        // URLRequest 생성
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("WCONfRfv8aio2yPtqOYWcWZKMltIj9IkkkCkFeyl", forHTTPHeaderField: "X-Parse-Application-Id")
        urlRequest.addValue("9EjhBUWG4G9aql4Q2GlTr9NqriQxbpaR2XCYQTSg", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        // MARK: - URLSession으로 API를 호출하기
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            
            // 에러가 있다면 에러 출력
            // httpResponse 없다며 에러
            // httpResponse.statusCode == 상태코드
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                return completion(.failure(ApiError.unKnown(error)))
            }
            
            // httpResponse 상태코드가 401 이라면 에러
            switch httpResponse.statusCode {
            case 401:
                return completion(.failure(.unAuthorized))
            default:
                print("default: \(httpResponse.statusCode)⭐️")
            }
            
            // 데이터 언래핑
            if let jsonData = data {
                // JSON -> Struct 디코딩 하고 있는작업 == 데이터 파싱⭐️
                do {
                    let response = try JSONDecoder().decode(UserResponse.self, from: jsonData)
                    completion(.success(response))
                    
                    // 파싱에 실패하면 에러
                } catch {
                    completion(.failure(.passingError))
                }
            }
            
        }.resume()
        
        
    }
    
    /// - Parameters:
    ///   - sessionToken: 세션토큰
    ///   - completion: 응답타입 클로저 터트리기
    // MARK: - 현재 사용자 검색하기 Api "GET"
    static func currentUserRetrievingWithObservable(sessionToken: String, completion: @escaping ((Result<UserResponse, ApiError>) -> Void)) {
        
        // MARK: - URLRequest를 만든다
        // https://parseapi.back4app.com/users/me
        // baseURL = https://parseapi.back4app.com/
        let urlString = baseURL + "users/" + "me"
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(.notAllowUrl))
        }
        
        // URLRequest 생성
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("WCONfRfv8aio2yPtqOYWcWZKMltIj9IkkkCkFeyl", forHTTPHeaderField: "X-Parse-Application-Id")
        urlRequest.addValue("9EjhBUWG4G9aql4Q2GlTr9NqriQxbpaR2XCYQTSg", forHTTPHeaderField: "X-Parse-REST-API-Key")
        urlRequest.addValue(sessionToken, forHTTPHeaderField: "X-Parse-Session-Token")
        
        // MARK: - URLSession으로 API를 호출하기
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            
            // 에러가 있다면 에러 출력
            // httpResponse 없다며 에러
            // httpResponse.statusCode == 상태코드
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                return completion(.failure(ApiError.unKnown(error)))
            }
            
            // httpResponse 상태코드가 401 이라면 에러
            switch httpResponse.statusCode {
            case 401:
                return completion(.failure(.unAuthorized))
            default:
                print("default: \(httpResponse.statusCode)⭐️")
            }
            
            // 데이터 언래핑
            if let jsonData = data {
                // JSON -> Struct 디코딩 하고 있는작업 == 데이터 파싱⭐️
                do {
                    let response = try JSONDecoder().decode(UserResponse.self, from: jsonData)
                    completion(.success(response))
                    // 파싱에 실패하면 에러
                } catch {
                    completion(.failure(.passingError))
                }
            }
            
        }.resume()
        
    }
    
    /// - Parameters:
    ///   - sessionToken: 세션토큰
    ///   - userName: 수정할 유저닉네임
    ///   - email: 수정할 이메일
    ///   - completion: 응답 클로저 터트리기
    // MARK: - 유저 정보 수정 Api "PUT
    static func editUserInformationWithObservable(sessionToken: String, objectId: String, userName: String, email: String, completion: @escaping ((Result<EditUser, ApiError>) -> Void)) {
        
        // MARK: - URLRequest를 만든다
        // https://parseapi.back4app.com/users/jSSAQpjmWC
        // baseURL = https://parseapi.back4app.com/
        let urlString = baseURL + "users/" + objectId
        
        let requestParams: [String:Any] = [
            "username":userName,
            "email":email,
        ]
        
        guard let url: URL = URL(string: urlString) else {
            return completion(.failure(.notAllowUrl))
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("WCONfRfv8aio2yPtqOYWcWZKMltIj9IkkkCkFeyl", forHTTPHeaderField: "X-Parse-Application-Id")
        urlRequest.addValue("9EjhBUWG4G9aql4Q2GlTr9NqriQxbpaR2XCYQTSg", forHTTPHeaderField: "X-Parse-REST-API-Key")
        urlRequest.addValue(sessionToken, forHTTPHeaderField: "X-Parse-Session-Token")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "PUT"
        
        do {
            // 딕셔너리를 JSONData 로 만들기
            let jsonData: Data = try JSONSerialization.data(withJSONObject: requestParams, options: [.prettyPrinted])
            // JSON형태로 만든 데이터를 httpBody에 넣기
            urlRequest.httpBody = jsonData
        } catch {
            // JSON serialization failed
            return completion(.failure(.jsonEncodingError))
        }
        
        // MARK: - URLSession으로 API를 호출한다 && API호출에 대한 응답을 받는다
        // 만든URLRequest를 가지고 데이터 추출
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            
            // 에러가 있다면 에러 출력
            // httpResponse 없다며 에러
            guard let httpResponse: HTTPURLResponse = urlResponse as? HTTPURLResponse else {
                return completion(.failure(ApiError.unKnown(error)))
            }
            
            // httpResponse 상태코드가 401 이라면 에러
            switch httpResponse.statusCode {
            case 401:
                return completion(.failure(.unAuthorized))
            default:
                print("default: \(httpResponse.statusCode)⭐️")
            }
            
            // 데이터 언래핑
            if let jsonData: Data = data {
                // JSON -> Struct 디코딩 하고 있는작업 == 데이터 파싱⭐️
                // MARK: - 데이터파싱
                do {
                    let response = try JSONDecoder().decode(EditUser.self, from: jsonData)
                    completion(.success(response))
                    // 파싱에 실패하면 에러
                } catch {
                    completion(.failure(.passingError))
                }
            }
            
        }.resume()
        
        
        
        
    }
    
    /// - Parameters:
    ///   - sessionToken: 유저 세션토큰
    ///   - objectId: 유저 아이디
    ///   - completion: 응답 클로저 터트리기
    // MARK: - 유저 삭제하기 Api "DELETE"
    static func deleteUserWithObservable(sessionToken: String, objectId: String, completion: @escaping ((Result<UserResponse, ApiError>) -> Void)) {
        
        print(#fileID, #function, #line, "deleteUserAPI 호출됨⭐️")
        
        // MARK: - URLRequest를 만든다
        // https://parseapi.back4app.com/users/a9JbehvWhv
        // baseURL = https://parseapi.back4app.com/
        let urlString = baseURL + "users/" + objectId
        
        
        guard let url: URL = URL(string: urlString) else {
            return completion(.failure(.notAllowUrl))
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("WCONfRfv8aio2yPtqOYWcWZKMltIj9IkkkCkFeyl", forHTTPHeaderField: "X-Parse-Application-Id")
        urlRequest.addValue("9EjhBUWG4G9aql4Q2GlTr9NqriQxbpaR2XCYQTSg", forHTTPHeaderField: "X-Parse-REST-API-Key")
        urlRequest.addValue(sessionToken, forHTTPHeaderField: "X-Parse-Session-Token")
        urlRequest.httpMethod = "DELETE"
        
        // MARK: - URLSession으로 API를 호출한다 && API호출에 대한 응답을 받는다
        // 만든URLRequest를 가지고 데이터 추출
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            
            // 에러가 있다면 에러 출력
            // httpResponse 없다며 에러
            guard let httpResponse: HTTPURLResponse = urlResponse as? HTTPURLResponse else {
                return completion(.failure(ApiError.unKnown(error)))
            }
            
            // httpResponse 상태코드가 401 이라면 에러
            switch httpResponse.statusCode {
            case 401:
                return completion(.failure(.unAuthorized))
            default:
                print("default: \(httpResponse.statusCode)⭐️")
            }
            
            // 데이터 언래핑
            if let jsonData: Data = data {
                // JSON -> Struct 디코딩 하고 있는작업 == 데이터 파싱⭐️
                // MARK: - 데이터파싱
                do {
                    let response = try JSONDecoder().decode(UserResponse.self, from: jsonData)
                    completion(.success(response))
                    // 파싱에 실패하면 에러
                } catch {
                    completion(.failure(.passingError))
                }
            }
            
        }.resume()
    }
    
    /// - Parameters:
    ///   - email: 유저이메일
    ///   - completion: http응답 클로저 터트리기
    // MARK: - 확인이메일요청 Api "POST"
    static func verificationEmailRequestWithObservable(email: String, completion: @escaping ((Result<UserResponse, ApiError>) -> Void)) {
        
        let requestParams: [String:Any] = [
            "email":email,
        ]
        
        // MARK: - URLRequest를 만든다
        // https://parseapi.back4app.com/verificationEmailRequest
        // baseURL = https://parseapi.back4app.com/
        let urlString = baseURL + "verificationEmailRequest/"
        
        guard let url: URL = URL(string: urlString) else {
            return completion(.failure(.notAllowUrl))
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("WCONfRfv8aio2yPtqOYWcWZKMltIj9IkkkCkFeyl", forHTTPHeaderField: "X-Parse-Application-Id")
        urlRequest.addValue("9EjhBUWG4G9aql4Q2GlTr9NqriQxbpaR2XCYQTSg", forHTTPHeaderField: "X-Parse-REST-API-Key")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        
        
        do {
            // 딕셔너리를 JSONData 로 만들기
            let jsonData: Data = try JSONSerialization.data(withJSONObject: requestParams, options: [.prettyPrinted])
            // JSON형태로 만든 데이터를 httpBody에 넣기
            urlRequest.httpBody = jsonData
        } catch {
            // JSON serialization failed
            return completion(.failure(.jsonEncodingError))
        }
        
        
        // MARK: - URLSession으로 API를 호출한다 && API호출에 대한 응답을 받는다
        // 만든URLRequest를 가지고 데이터 추출
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            
            // 에러가 있다면 에러 출력
            // httpResponse 없다며 에러
            guard let httpResponse: HTTPURLResponse = urlResponse as? HTTPURLResponse else {
                return completion(.failure(ApiError.unKnown(error)))
            }
            
            // httpResponse 상태코드가 401 이라면 에러
            switch httpResponse.statusCode {
            case 401:
                return completion(.failure(.unAuthorized))
            default:
                print("default: \(httpResponse.statusCode)⭐️")
            }
            
            // 데이터 언래핑
            if let jsonData: Data = data {
                // JSON -> Struct 디코딩 하고 있는작업 == 데이터 파싱⭐️
                // MARK: - 데이터파싱
                do {
                    let response = try JSONDecoder().decode(UserResponse.self, from: jsonData)
                    completion(.success(response))
                    // 파싱에 실패하면 에러
                } catch {
                    completion(.failure(.passingError))
                }
            }
            
        }.resume()
    }
    
    /// - Parameters:
    ///   - email: 유저이메일
    ///   - completion: http응답 클로저 터트리기
    // MARK: - 확인이메일요청 Api "POST"
    static func requestPasswordResetWithObservable(email: String, completion: @escaping ((Result<UserResponse, ApiError>) -> Void)) {
        
        let requestParams: [String:Any] = [
            "email":email,
        ]
        
        // MARK: - URLRequest를 만든다
        // https://parseapi.back4app.com/requestPasswordReset
        // baseURL = https://parseapi.back4app.com/
        let urlString = baseURL + "requestPasswordReset"
        
        guard let url: URL = URL(string: urlString) else {
            return completion(.failure(.notAllowUrl))
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("WCONfRfv8aio2yPtqOYWcWZKMltIj9IkkkCkFeyl", forHTTPHeaderField: "X-Parse-Application-Id")
        urlRequest.addValue("9EjhBUWG4G9aql4Q2GlTr9NqriQxbpaR2XCYQTSg", forHTTPHeaderField: "X-Parse-REST-API-Key")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        
        
        do {
            // 딕셔너리를 JSONData 로 만들기
            let jsonData: Data = try JSONSerialization.data(withJSONObject: requestParams, options: [.prettyPrinted])
            // JSON형태로 만든 데이터를 httpBody에 넣기
            urlRequest.httpBody = jsonData
        } catch {
            // JSON serialization failed
            return completion(.failure(.jsonEncodingError))
        }
        
        
        // MARK: - URLSession으로 API를 호출한다 && API호출에 대한 응답을 받는다
        // 만든URLRequest를 가지고 데이터 추출
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            
            // 에러가 있다면 에러 출력
            // httpResponse 없다며 에러
            guard let httpResponse: HTTPURLResponse = urlResponse as? HTTPURLResponse else {
                return completion(.failure(ApiError.unKnown(error)))
            }
            
            // httpResponse 상태코드가 401 이라면 에러
            switch httpResponse.statusCode {
            case 401:
                return completion(.failure(.unAuthorized))
            default:
                print("default: \(httpResponse.statusCode)⭐️")
            }
            
            // 데이터 언래핑
            if let jsonData: Data = data {
                // JSON -> Struct 디코딩 하고 있는작업 == 데이터 파싱⭐️
                // MARK: - 데이터파싱
                do {
                    let response = try JSONDecoder().decode(UserResponse.self, from: jsonData)
                    completion(.success(response))
                    // 파싱에 실패하면 에러
                } catch {
                    completion(.failure(.passingError))
                }
            }
            
        }.resume()
    }
    
    /// - Parameters:
    ///   - userName: 유저닉네임
    ///   - email: 유저이메일
    ///   - password: 유저페스워드
    ///   - completion: 응답 클로저 터트리기
    // MARK: - 회원가입하고 로그인하기
    static func signupUserAndLoginUserWithObservable(userName: String, email: String, password: String,  completion: @escaping ((Result<UserResponse, ApiError>) -> Void)) {
        
        self.signupAPI(userName: userName, email: email, password: password) { result in
            
            switch result {
            case .success(let successResponse):
                self.loginAPI(userName: userName, password: password) { response in
                    completion(.success(successResponse))
                }
            case .failure(let failure):
                completion(.failure(failure))
            }
            
        }
    }
    
    
    //sessionToken: String, objectId: String
    /// - Parameters:
    ///   - sessionTokens: 삭제할 유저 토큰 배열
    ///   - ObjectIds: 삭제할 유저 Id 배열
    ///   - completion: 삭제가 완료된 아이디
    // MARK: - 유저 동시 삭제
    static func deleteSelectedUsersWithObservable(deleteUserTokenAndIdDictionary: [String:String],
                                       completion: @escaping ([String:String]) -> Void) {
        
        
        // Create a dispatch group
        let group = DispatchGroup()
        
        // 성공적으로 삭제가 된 유저들
        var deletedUserInformationDictionary: [String:String] = [:]
        
        deleteUserTokenAndIdDictionary.forEach { keyTokenValueId in
            
            
            // 디스패치 그룹에 넣음⭐️
            group.enter()
            
            self.deleteUserAPI(sessionToken: keyTokenValueId.key, objectId: keyTokenValueId.value) { result in
                switch result {
                case .success(_):
//
//                    guard let userId = response.objectID else { return }
//                    guard let tokenId = response.sessionToken else { return }
                    
                    // 삭제된 토큰과 아이디를 삭제된 토큰, 아이디 배열에 넣어주기
                    deletedUserInformationDictionary.updateValue(keyTokenValueId.value, forKey: keyTokenValueId.key)
                    
                case .failure(let failure):
                    print("inner deleteUserAPI - failure: \(failure)")
                    
                }
                
                group.leave()
                
            }// 단일 삭제 api 호출
        }
        
        // Configure a completion callback
        group.notify(queue: .main) {
            // All requests completed
            print("모든 유저 삭제됨")
            completion(deletedUserInformationDictionary)
        }

        
        
    }
    
}
