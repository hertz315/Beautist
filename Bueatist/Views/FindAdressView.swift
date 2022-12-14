//
//  FindAdressView.swift
//  Bueatist
//
//  Created by Hertz on 12/14/22.
//

import SwiftUI
import UIKit
import WebKit
import Combine

struct FindAdressView: UIViewControllerRepresentable {
    
    // MARK: - Properties
    @StateObject var signUpVM: BeautistViewModel
    @Environment(\.presentationMode) var presentationMode
    
    
    // 웹뷰 생성
    var webView: WKWebView?
    // webView 가 로딩될 동안 보여줄 UIActivityIndicatorView 도 인스턴스
    let indicator = UIActivityIndicatorView(style: .medium)
    
    
    // MARK: - SwiftUI 에서 나타낼 뷰를 반환⭐️
    func makeUIViewController(context: Context) ->  FindAdressVC {
        let controller = FindAdressVC()
        return controller
    }
    
    // MARK: - 업데이트 할때 마다 함수 호출
    func updateUIViewController(_ uiViewController: FindAdressVC, context: Context) {
        
    }
    
    // MARK: - 코디네이터 생성
    func makeCoordinator() -> FindAdressView.Coordinator {
        return Coordinator(parent: self)
    }
    
    // MARK: - 코디네이터
    class Coordinator {
        
        private let parent: FindAdressView
        
        init(parent: FindAdressView) {
            self.parent = parent
        }
    }
    
}











//
//struct FindAdressView_Previews: PreviewProvider {
//    static var previews: some View {
//        FindAdressView(signUpVM: signUpView)
//    }
//}
