//////
//////  BueatistAPI.swift
//////  Bueatist
//////
//////  Created by Hertz on 12/9/22.
//////
//
//import Foundation
//import RxSwift
//import RxCocoa
//
//extension BeautistUserApi {
//
//    // ⭐️
//    /// - Parameters:
//    ///   - userName: 유저닉네임
//    ///   - email: 유저이메일
//    ///   - password: 유저패스워드
//    // MARK: - 회원가입 Api - "POST"
//    static func signupWithObservable(userName: String, email: String, password: String) -> Observable<UserResponse> {
//
//        let requestParams: [String:Any] = [
//            "username":userName,
//            "email":email,
//            "password":password
//        ]
//
//        // MARK: - URLRequest를 만든다
//        let urlString: String = baseURL + "users"
//
//        guard let url: URL = URL(string: urlString) else {
//            return Observable.error(ApiError.notAllowUrl)
//        }
//
//        var urlRequest: URLRequest = URLRequest(url: url)
//        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
//        urlRequest.addValue("WCONfRfv8aio2yPtqOYWcWZKMltIj9IkkkCkFeyl", forHTTPHeaderField: "X-Parse-Application-Id")
//        urlRequest.addValue("9EjhBUWG4G9aql4Q2GlTr9NqriQxbpaR2XCYQTSg", forHTTPHeaderField: "X-Parse-REST-API-Key")
//        urlRequest.addValue("1", forHTTPHeaderField: "X-Parse-Revocable-Session")
//        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        urlRequest.httpMethod = "POST"
//
//        do {
//            // 딕셔너리를 JSONData 로 만들기
//            let jsonData: Data = try JSONSerialization.data(withJSONObject: requestParams, options: [.prettyPrinted])
//            // JSON형태로 만든 데이터를 httpBody에 넣기
//            urlRequest.httpBody = jsonData
//        } catch {
//            // JSON serialization failed
//            return Observable.error(ApiError.jsonEncodingError)
//        }
//
//        // MARK: - URLSession으로 API를 호출한다
//        // MARK: - API호출에 대한 응답을 받는다
//        // 만든URLRequest를 가지고 데이터 추출
//        return URLSession.shared.rx.response(request: urlRequest)
//            .map({ (response: HTTPURLResponse, data: Data) -> UserResponse in
//
//                switch response.statusCode {
//                case 401:
//                    throw ApiError.unAuthorized
//                default:
//                    print("default: \(response.statusCode)⭐️")
//                }
//
//                if !(200...299).contains(response.statusCode) {
//                    throw ApiError.badStatus(code: response.statusCode)
//                }
//
//                // MARK: - 데이터파싱
//                do {
//                    let response = try JSONDecoder().decode(UserResponse.self, from: data)
//                    return response
//
//                    // 파싱에 실패하면 에러
//                } catch {
//                    throw ApiError.passingError
//                }
//
//            })
//
//    }
//
//    // ⭐️
//    /// - Parameters:
//    ///   - userName: 유저이름
//    ///   - password: 유저패스워드
//    // MARK: - 로그인하기 API - "GET"
//    static func loginWithObservable(userName: String, password: String) -> Observable<UserResponse> {
//
//        // MARK: - URLRequest를 만든다
//        // https://parseapi.back4app.com/login?username=hertz315&password=%40%40Ghdrn315
//        var urlComponents = URLComponents(string: baseURL + "login?")!
//        urlComponents.queryItems = [
//            URLQueryItem(name: "username", value: userName),
//            URLQueryItem(name: "password", value: password)
//        ]
//
//        guard let url = urlComponents.url else {
//            // ⭐️에러보내고 스트림 끊킴⭐️
//            return Observable.error(ApiError.notAllowUrl)
//        }
//
//
//        // URLRequest 생성
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "GET"
//        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
//        urlRequest.addValue("WCONfRfv8aio2yPtqOYWcWZKMltIj9IkkkCkFeyl", forHTTPHeaderField: "X-Parse-Application-Id")
//        urlRequest.addValue("9EjhBUWG4G9aql4Q2GlTr9NqriQxbpaR2XCYQTSg", forHTTPHeaderField: "X-Parse-REST-API-Key")
//        urlRequest.addValue("1", forHTTPHeaderField: "X-Parse-Revocable-Session")
//
//        // MARK: - URLSession으로 API를 호출한다
//        return URLSession.shared.rx.response(request: urlRequest)
//            .map({ (response: HTTPURLResponse, data: Data) -> UserResponse in
//                switch response.statusCode {
//                case 401:
//                    // 에러를 던지면 밖으로 나가기 때문에 리턴안해도 됨
//                    throw ApiError.unAuthorized
//                default:
//                    print("default: \(response.statusCode)⭐️")
//                }
//
//                if !(200...299).contains(response.statusCode) {
//                    throw ApiError.badStatus(code: response.statusCode)
//                }
//
//                // MARK: - 데이터파싱
//                do {
//                    let sucessResponse = try JSONDecoder().decode(UserResponse.self, from: data)
//                    return sucessResponse
//
//                    // 파싱에 실패하면 에러
//                } catch {
//                    throw ApiError.passingError
//                }
//
//            })
//
//
//        // 3. API 호출에대한 응답값을 받는다
//
//
//    }
//
//    // ⭐️
//    /// - Parameters:
//    ///   - objectId: 유저객체ID
//    ///   - completion: 응답타입 클로저 터트리기
//    // MARK: - 특정 유저 검색하기 API "GET"
//    static func userRetrievingWithObservable(objectId: String) -> Observable<UserResponse> {
//
//        // MARK: - URLRequest를 만든다
//        // https://parseapi.back4app.com/users/ndDZyHxTVc
//        // baseURL = https://parseapi.back4app.com/
//        let urlString = baseURL + "users/" + objectId
//
//        guard let url = URL(string: urlString) else {
//            return Observable.error(ApiError.notAllowUrl)
//        }
//
//        // URLRequest 생성
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "GET"
//        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
//        urlRequest.addValue("WCONfRfv8aio2yPtqOYWcWZKMltIj9IkkkCkFeyl", forHTTPHeaderField: "X-Parse-Application-Id")
//        urlRequest.addValue("9EjhBUWG4G9aql4Q2GlTr9NqriQxbpaR2XCYQTSg", forHTTPHeaderField: "X-Parse-REST-API-Key")
//
//        // MARK: - URLSession으로 API를 호출하기
//        return URLSession.shared.rx.response(request: urlRequest)
//            .map({ (response: HTTPURLResponse, data: Data) -> UserResponse in
//
//                // httpResponse 상태코드가 401 이라면 에러
//                switch response.statusCode {
//                case 401:
//                    throw ApiError.unAuthorized
//                default:
//                    print("default: \(response.statusCode)⭐️")
//                }
//
//                // JSON -> Struct 디코딩 하고 있는작업 == 데이터 파싱⭐️
//                do {
//                    let response = try JSONDecoder().decode(UserResponse.self, from: data)
//                    return response
//                    // 파싱에 실패하면 에러
//                } catch {
//                    throw ApiError.passingError
//                }
//            })
//
//
//
//
//
//
//
//    }
//
//    // ⭐️
//    /// - Parameters:
//    ///   - sessionToken: 세션토큰
//    ///   - completion: 응답타입 클로저 터트리기
//    // MARK: - 현재 사용자 검색하기 Api "GET"
//    static func currentUserRetrievingWithObservable(sessionToken: String) -> Observable<Result<UserResponse, ApiError>> {
//
//        // MARK: - URLRequest를 만든다
//        // https://parseapi.back4app.com/users/me
//        // baseURL = https://parseapi.back4app.com/
//        let urlString = baseURL + "users/" + "me"
//
//        guard let url = URL(string: urlString) else {
//            return Observable.just(Result.failure(.notAllowUrl))
//        }
//
//        // URLRequest 생성
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "GET"
//        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
//        urlRequest.addValue("WCONfRfv8aio2yPtqOYWcWZKMltIj9IkkkCkFeyl", forHTTPHeaderField: "X-Parse-Application-Id")
//        urlRequest.addValue("9EjhBUWG4G9aql4Q2GlTr9NqriQxbpaR2XCYQTSg", forHTTPHeaderField: "X-Parse-REST-API-Key")
//        urlRequest.addValue(sessionToken, forHTTPHeaderField: "X-Parse-Session-Token")
//
//        // MARK: - URLSession으로 API를 호출하기
//        return URLSession.shared.rx.response(request: urlRequest)
//            .map({ (response: HTTPURLResponse, data: Data) -> Result<UserResponse, ApiError> in
//
//                switch response.statusCode {
//                case 401:
//                    return Result.failure(ApiError.unAuthorized)
//                default:
//                    print("default: \(response.statusCode)⭐️")
//                }
//
//                // 데이터 언래핑
//                do {
//                    let response = try JSONDecoder().decode(UserResponse.self, from: data)
//                    return Result.success(response)
//                    // 파싱에 실패하면 에러
//                } catch {
//                    return Result.failure(ApiError.passingError)
//                }
//
//            })
//
//    }
//
//    /// - Parameters:
//    ///   - sessionToken: 세션토큰
//    ///   - userName: 수정할 유저닉네임
//    ///   - email: 수정할 이메일
//    // MARK: - 유저 정보 수정 Api "PUT
//    static func editUserInformationWithObservable(sessionToken: String, objectId: String, userName: String, email: String, completion: @escaping ((Result<EditUser, ApiError>) -> Void)) {
//
//        // MARK: - URLRequest를 만든다
//        // https://parseapi.back4app.com/users/jSSAQpjmWC
//        // baseURL = https://parseapi.back4app.com/
//        let urlString = baseURL + "users/" + objectId
//
//        let requestParams: [String:Any] = [
//            "username":userName,
//            "email":email,
//        ]
//
//        guard let url: URL = URL(string: urlString) else {
//            return completion(.failure(.notAllowUrl))
//        }
//
//        var urlRequest: URLRequest = URLRequest(url: url)
//        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
//        urlRequest.addValue("WCONfRfv8aio2yPtqOYWcWZKMltIj9IkkkCkFeyl", forHTTPHeaderField: "X-Parse-Application-Id")
//        urlRequest.addValue("9EjhBUWG4G9aql4Q2GlTr9NqriQxbpaR2XCYQTSg", forHTTPHeaderField: "X-Parse-REST-API-Key")
//        urlRequest.addValue(sessionToken, forHTTPHeaderField: "X-Parse-Session-Token")
//        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        urlRequest.httpMethod = "PUT"
//
//        do {
//            // 딕셔너리를 JSONData 로 만들기
//            let jsonData: Data = try JSONSerialization.data(withJSONObject: requestParams, options: [.prettyPrinted])
//            // JSON형태로 만든 데이터를 httpBody에 넣기
//            urlRequest.httpBody = jsonData
//        } catch {
//            // JSON serialization failed
//            return completion(.failure(.jsonEncodingError))
//        }
//
//        // MARK: - URLSession으로 API를 호출한다 && API호출에 대한 응답을 받는다
//        // 만든URLRequest를 가지고 데이터 추출
//        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
//
//            // 에러가 있다면 에러 출력
//            // httpResponse 없다며 에러
//            guard let httpResponse: HTTPURLResponse = urlResponse as? HTTPURLResponse else {
//                return completion(.failure(ApiError.unKnown(error)))
//            }
//
//            // httpResponse 상태코드가 401 이라면 에러
//            switch httpResponse.statusCode {
//            case 401:
//                return completion(.failure(.unAuthorized))
//            default:
//                print("default: \(httpResponse.statusCode)⭐️")
//            }
//
//            // 데이터 언래핑
//            if let jsonData: Data = data {
//                // JSON -> Struct 디코딩 하고 있는작업 == 데이터 파싱⭐️
//                // MARK: - 데이터파싱
//                do {
//                    let response = try JSONDecoder().decode(EditUser.self, from: jsonData)
//                    completion(.success(response))
//                    // 파싱에 실패하면 에러
//                } catch {
//                    completion(.failure(.passingError))
//                }
//            }
//
//        }.resume()
//
//
//
//
//    }
//
//    // ⭐️
//    /// - Parameters:
//    ///   - sessionToken: 유저 세션토큰
//    ///   - objectId: 유저 아이디
//    ///   - completion: 응답 클로저 터트리기
//    // MARK: - 유저 삭제하기 Api "DELETE"
//    static func deleteUserWithObservable(sessionToken: String, objectId: String) -> Observable<UserResponse> {
//
//        print(#fileID, #function, #line, "deleteUserAPI 호출됨⭐️")
//
//        // MARK: - URLRequest를 만든다
//        // https://parseapi.back4app.com/users/a9JbehvWhv
//        // baseURL = https://parseapi.back4app.com/
//        let urlString = baseURL + "users/" + objectId
//
//        guard let url: URL = URL(string: urlString) else {
//            return Observable.error(ApiError.notAllowUrl)
//        }
//
//        var urlRequest: URLRequest = URLRequest(url: url)
//        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
//        urlRequest.addValue("WCONfRfv8aio2yPtqOYWcWZKMltIj9IkkkCkFeyl", forHTTPHeaderField: "X-Parse-Application-Id")
//        urlRequest.addValue("9EjhBUWG4G9aql4Q2GlTr9NqriQxbpaR2XCYQTSg", forHTTPHeaderField: "X-Parse-REST-API-Key")
//        urlRequest.addValue(sessionToken, forHTTPHeaderField: "X-Parse-Session-Token")
//        urlRequest.httpMethod = "DELETE"
//
//        // MARK: - URLSession으로 API를 호출한다 && API호출에 대한 응답을 받는다
//        // 만든URLRequest를 가지고 데이터 추출
//        return URLSession.shared.rx.response(request: urlRequest)
//            .map({ (response: HTTPURLResponse, data: Data) in
//
//                switch response.statusCode {
//                case 401:
//                    throw ApiError.unAuthorized
//                default:
//                    print("default: \(response.statusCode)⭐️")
//                }
//
//                // 응답코드가 200...299가 아니라면 에러던지기
//                if !(200...299).contains(response.statusCode) {
//                    throw ApiError.badStatus(code: response.statusCode)
//                }
//
//                // MARK: - 데이터파싱
//                do {
//                    let response = try JSONDecoder().decode(UserResponse.self, from: data)
//                    return response
//                    // 파싱에 실패하면 에러
//                } catch {
//                    throw ApiError.passingError
//                }
//
//            })
//
//    }
//
//    /// - Parameters:
//    ///   - email: 유저이메일
//    ///   - completion: http응답 클로저 터트리기
//    // MARK: - 확인이메일요청 Api "POST"
//    static func verificationEmailRequestWithObservable(email: String, completion: @escaping ((Result<UserResponse, ApiError>) -> Void)) {
//
//        let requestParams: [String:Any] = [
//            "email":email,
//        ]
//
//        // MARK: - URLRequest를 만든다
//        // https://parseapi.back4app.com/verificationEmailRequest
//        // baseURL = https://parseapi.back4app.com/
//        let urlString = baseURL + "verificationEmailRequest/"
//
//        guard let url: URL = URL(string: urlString) else {
//            return completion(.failure(.notAllowUrl))
//        }
//
//        var urlRequest: URLRequest = URLRequest(url: url)
//        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
//        urlRequest.addValue("WCONfRfv8aio2yPtqOYWcWZKMltIj9IkkkCkFeyl", forHTTPHeaderField: "X-Parse-Application-Id")
//        urlRequest.addValue("9EjhBUWG4G9aql4Q2GlTr9NqriQxbpaR2XCYQTSg", forHTTPHeaderField: "X-Parse-REST-API-Key")
//        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        urlRequest.httpMethod = "POST"
//
//
//        do {
//            // 딕셔너리를 JSONData 로 만들기
//            let jsonData: Data = try JSONSerialization.data(withJSONObject: requestParams, options: [.prettyPrinted])
//            // JSON형태로 만든 데이터를 httpBody에 넣기
//            urlRequest.httpBody = jsonData
//        } catch {
//            // JSON serialization failed
//            return completion(.failure(.jsonEncodingError))
//        }
//
//
//        // MARK: - URLSession으로 API를 호출한다 && API호출에 대한 응답을 받는다
//        // 만든URLRequest를 가지고 데이터 추출
//        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
//
//            // 에러가 있다면 에러 출력
//            // httpResponse 없다며 에러
//            guard let httpResponse: HTTPURLResponse = urlResponse as? HTTPURLResponse else {
//                return completion(.failure(ApiError.unKnown(error)))
//            }
//
//            // httpResponse 상태코드가 401 이라면 에러
//            switch httpResponse.statusCode {
//            case 401:
//                return completion(.failure(.unAuthorized))
//            default:
//                print("default: \(httpResponse.statusCode)⭐️")
//            }
//
//            // 데이터 언래핑
//            if let jsonData: Data = data {
//                // JSON -> Struct 디코딩 하고 있는작업 == 데이터 파싱⭐️
//                // MARK: - 데이터파싱
//                do {
//                    let response = try JSONDecoder().decode(UserResponse.self, from: jsonData)
//                    completion(.success(response))
//                    // 파싱에 실패하면 에러
//                } catch {
//                    completion(.failure(.passingError))
//                }
//            }
//
//        }.resume()
//    }
//
//    /// - Parameters:
//    ///   - email: 유저이메일
//    ///   - completion: http응답 클로저 터트리기
//    // MARK: - 확인이메일요청 Api "POST"
//    static func requestPasswordResetWithObservable(email: String, completion: @escaping ((Result<UserResponse, ApiError>) -> Void)) {
//
//        let requestParams: [String:Any] = [
//            "email":email,
//        ]
//
//        // MARK: - URLRequest를 만든다
//        // https://parseapi.back4app.com/requestPasswordReset
//        // baseURL = https://parseapi.back4app.com/
//        let urlString = baseURL + "requestPasswordReset"
//
//        guard let url: URL = URL(string: urlString) else {
//            return completion(.failure(.notAllowUrl))
//        }
//
//        var urlRequest: URLRequest = URLRequest(url: url)
//        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
//        urlRequest.addValue("WCONfRfv8aio2yPtqOYWcWZKMltIj9IkkkCkFeyl", forHTTPHeaderField: "X-Parse-Application-Id")
//        urlRequest.addValue("9EjhBUWG4G9aql4Q2GlTr9NqriQxbpaR2XCYQTSg", forHTTPHeaderField: "X-Parse-REST-API-Key")
//        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        urlRequest.httpMethod = "POST"
//
//
//        do {
//            // 딕셔너리를 JSONData 로 만들기
//            let jsonData: Data = try JSONSerialization.data(withJSONObject: requestParams, options: [.prettyPrinted])
//            // JSON형태로 만든 데이터를 httpBody에 넣기
//            urlRequest.httpBody = jsonData
//        } catch {
//            // JSON serialization failed
//            return completion(.failure(.jsonEncodingError))
//        }
//
//
//        // MARK: - URLSession으로 API를 호출한다 && API호출에 대한 응답을 받는다
//        // 만든URLRequest를 가지고 데이터 추출
//        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
//
//            // 에러가 있다면 에러 출력
//            // httpResponse 없다며 에러
//            guard let httpResponse: HTTPURLResponse = urlResponse as? HTTPURLResponse else {
//                return completion(.failure(ApiError.unKnown(error)))
//            }
//
//            // httpResponse 상태코드가 401 이라면 에러
//            switch httpResponse.statusCode {
//            case 401:
//                return completion(.failure(.unAuthorized))
//            default:
//                print("default: \(httpResponse.statusCode)⭐️")
//            }
//
//            // 데이터 언래핑
//            if let jsonData: Data = data {
//                // JSON -> Struct 디코딩 하고 있는작업 == 데이터 파싱⭐️
//                // MARK: - 데이터파싱
//                do {
//                    let response = try JSONDecoder().decode(UserResponse.self, from: jsonData)
//                    completion(.success(response))
//                    // 파싱에 실패하면 에러
//                } catch {
//                    completion(.failure(.passingError))
//                }
//            }
//
//        }.resume()
//    }
//
//    // ⭐️
//    /// - Parameters:
//    ///   - userName: 유저닉네임
//    ///   - email: 유저이메일
//    ///   - password: 유저페스워드
//    // MARK: - 회원가입하고 로그인하기 / 연쇄 API 호출⭐️
//    static func signupUserAndLoginUserWithObservable(userName: String, email: String, password: String) -> Observable<UserResponse> {
//        /// 회원가입이 성공하면 리턴 그후 오퍼레이터 사용하여 로그인 API 호출
//        /// flatMapLatest 사용하면 첫번째Api 호출 응답값의 결과가 인자로 들어온다
//        return self.signupWithObservable(userName: userName, email: email, password: password)
//            .flatMapLatest { (signupResponse: UserResponse) in
//                self.loginWithObservable(userName: userName,
//                                         password: password)
//            }
//        /// 회원가입 여부와 로그인 여부를 공유
//            .share(replay: 1)
//
//    }
//
//    // ⭐️
//    //sessionToken: String, objectId: String
//    /// - Parameters:
//    ///   - sessionTokens: 삭제할 유저 토큰 배열
//    ///   - ObjectIds: 삭제할 유저 Id 배열
//    // MARK: - 동시 유저 삭제 / 동시 API 호출⭐️
//    static func deleteSelectedUsersWithObservable(deleteUserTokenAndIdDictionary: [String:String]) -> Observable<[String:String]> {
//        
//        let apiCallObservables = deleteUserTokenAndIdDictionary.map { id -> Observable<[String:String]> in
//
//           return self.deleteUserWithObservable(sessionToken: id.key, objectId: id.value)
//                .map { Observable.just([$0.sessionToken ?? "" : $0.objectID ?? ""])}
//                .compactMap {$0}
//                .flatMap{$0}
//            
//        
//        }
//           
//        return Observable.merge(apiCallObservables)
//        
//    }
//
//}
