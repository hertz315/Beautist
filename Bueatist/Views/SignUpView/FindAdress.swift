//
//  FindAdress.swift
//  Bueatist
//
//  Created by Hertz on 12/14/22.


import UIKit
import WebKit
import Combine

class FindAdressVC: UIViewController {


    // MARK: - Properties
    // 웹뷰 생성
    var webView: WKWebView?
    // webView 가 로딩될 동안 보여줄 UIActivityIndicatorView 도 인스턴스
    let indicator = UIActivityIndicatorView(style: .medium)

    var adress: String?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - UI
    private func configureUI() {
        view.backgroundColor = .white
//        setAttributes()
//        setContraints()
    }

    private func setAttributes() {
        // Java Script 가 보내는 메세지를 읽기 위해서 인스턴스 생성
        let contentController = WKUserContentController()
        // 메세지를 받기위해 add 메서드 사용
        contentController.add(self, name: "callBackHandler")

        // contentController 를 WKWebView 와 연결할 수 있도록 도와주는 WKWebViewConfiguration 이 필요합니다.
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController

        // webView 를 인스턴스화 해줍니다.
        webView = WKWebView(frame: .zero, configuration: configuration)
        // webView Delegate 위임.
        self.webView?.navigationDelegate = self

        // webView 가 우편번호 서비스 웹페이지를 띄울 수 있도록 URL 전달
        guard let url = URL(string: "https://hertz315.github.io/Kakao-PostCode/"),
            let webView = webView
            else { return }
        // URLRequest 를 생성해 webView 가 해당 URL 을 load 할 수 있도록 넘겨줍니다.
        let request = URLRequest(url: url)
        webView.load(request)
        indicator.startAnimating()
    }

    private func setContraints() {
        guard let webView = webView else { return }
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false

        webView.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            indicator.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: webView.centerYAnchor),
        ])
    }

    // MARK: - 코디네이터 생성
    func makeCoordinator() -> FindAdressVC.Coordinator {
        return Coordinator(parent: self)
    }

    // MARK: - 코디네이터
    class Coordinator {
        private let parent: FindAdressVC

        init(parent: FindAdressVC) {
            self.parent = parent
        }
    }


}

// Hanlder 가 있어야 Java Script 가 보내는 Message 를 정상적으로 수신할 수 있다.
extension FindAdressVC: WKScriptMessageHandler {
    ////     ⭐️ 함수가 호출되는 타이밍은 유저가 주소를 검색하고 어떤 값을 최종적으로 선택했을 때 호출되게 된다.
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if let data = message.body as? [String: Any] {
            self.adress = data["roadAddress"] as? String ?? ""
            // MARK: - 이전 뷰 Text에 바인딩 시키기 ⭐️
            
        }
        
        self.dismiss(animated: true) {
            print(self.adress ?? "")
        }
    }
}

//webView 가 로드될 때 indicator 를 보여줄 수 있도록 WKNavigationDelegate 프로토콜을 채택하고 코드를 구현
extension FindAdressVC: WKNavigationDelegate {
    
    // webView 로드가 실행될때 호출
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator.startAnimating()
    }
    
    // webView 로드가 끝날때 호출
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
        
    }
    
}

