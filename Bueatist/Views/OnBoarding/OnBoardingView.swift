//
//  OnBoardingView.swift
//  Bueatist
//
//  Created by Hertz on 12/12/22.
//

import SwiftUI

// MARK: - 폰트이름
//=== NanumGothic
//=== NanumGothicBold
//=== NanumGothicExtraBold

struct OnBoardingView: View {
    
    
    var body: some View {
        
        
        ZStack {
            /// 동영상
            Color.red
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack(alignment: .center, spacing: 0) {
                    Text("FindTattoo")
                        .lineLimit(nil)
                        .font(.custom("NanumGothicBold", size: 20))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("건너뛰기")
                        .lineLimit(nil)
                        .font(.custom("NanumGothicExtraBold", size: 12))
                        .foregroundColor(ColorManager.onBoardingBlack)
                }
                .padding(.horizontal, 16)
                .padding(.top, 67.5)
                .ignoresSafeArea(.all)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 24) {
                    Text("내지역 \n타투전문가")
                        .lineLimit(nil)
                        .font(.custom("NanumGothicExtraBold", size: 30))
                        .padding(.horizontal, 19.5)
                    
                    Button {
                        
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(ColorManager.onBoardingYellow)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .padding(.horizontal, 16)
                            .overlay(
                                Text("계속하기")
                                    .font(.custom("NanumGothicBold", size: 16))
                                    .foregroundColor(ColorManager.onBoardingBlack)
                            )
                    }

                    VStack {
                        HStack {
                            
                        }
                        
                        HStack {
                            
                        }
                    }
                    
                    
                    
                }
                
            }
        }
        
    }
}

//struct OnBoardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnBoardingView()
//    }
//}

//            VStack {
//                NavigationLink {
//                    SignUpView()
//                } label: {
//                    RoundedRectangle(cornerRadius: 10)
//                        .fill(Color.black)
//                        .frame(maxWidth: .infinity)
//                        .frame(height: 70)
//                        .overlay(
//                            Text("회원가입")
//                                .foregroundColor(.white)
//                                .font(.headline)
//                        )
//                }
//
//                NavigationLink {
//                    LogInView()
//                } label: {
//                    RoundedRectangle(cornerRadius: 10)
//                        .fill(Color.black)
//                        .frame(maxWidth: .infinity)
//                        .frame(height: 70)
//                        .overlay(
//                            Text("로그인")
//                                .foregroundColor(.white)
//                                .font(.headline)
//                        )
//                }
//
//
//            }
//            .padding()

