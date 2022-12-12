//
//  OnBoardingView.swift
//  Bueatist
//
//  Created by Hertz on 12/12/22.
//

import SwiftUI

struct OnBoardingView: View {
    var body: some View {
        NavigationView {
            
            VStack {
                NavigationLink {
                    SignUpView()
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 70)
                        .overlay(
                            Text("회원가입")
                                .foregroundColor(.white)
                                .font(.headline)
                        )
                }
                
                NavigationLink {
                    LogInView()
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 70)
                        .overlay(
                            Text("로그인")
                                .foregroundColor(.white)
                                .font(.headline)
                        )
                }

                
            }
            .padding()
        }
    }
}

//struct OnBoardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnBoardingView()
//    }
//}
