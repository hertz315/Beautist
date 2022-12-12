//
//  SignUpView.swift
//  Bueatist
//
//  Created by Hertz on 12/12/22.
//

import SwiftUI

struct SignUpView: View {
    
    @StateObject var signupVM = BeautistViewModel()
    
    // MARK: - 바디⭐️
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                
                titleSection
                    .padding()
                
                nickNameSection
                    .padding(.vertical)
                
                passwordSection
                    .padding(.vertical)
                
                emailSection
                    .padding(.vertical)
                
                signupButton
                    .padding()
                
                
            } // VStack
        } // Scrollview
    }
    
    // MARK: - 타이틀 섹션 ("회원가입)
    var titleSection: some View {
        HStack {
            Text("회원가입")
                .font(.largeTitle)
            Spacer()
        }
    }
    
    // MARK: - 닉네임 섹션
    var nickNameSection: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 5) {
                Text("닉네임")
                    .font(.headline)
                Image("RequireStar")
                    .resizable()
                    .frame(width: 15, height: 15)
                
            }
            .padding(.horizontal)
            
            HStack {
                TextField("닉네임을 입력하세요", text: $signupVM.userName)
                
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.gray)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
        }
        
        
    }
    
    // MARK: - 패스워드 섹션
    var passwordSection: some View {
        
        VStack(alignment: .leading) {
            
            HStack(spacing: 5) {
                Text("비밀번호")
                    .font(.headline)
                Image("RequireStar")
                    .resizable()
                    .frame(width: 15, height: 15)
                
            }
            .padding(.horizontal)
            
            HStack {
                SecureField("비밀번호를 입력해주세요", text: $signupVM.checkPassWord1)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.gray)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
            
            HStack {
                SecureField("비밀번호를 다시 입력해주세요", text: $signupVM.checkPassWord2)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.gray)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
            
            /// 비밀번호 유효성 확인 텍스트
            if signupVM.passwordValidCheck == false {
                Text("잘못된 비밀번호 입니다")
                    .padding(.horizontal)
                    .foregroundColor(Color.red)
            }
            
            
            
        }
    }
    
    // MARK: - 이메일 섹션
    var emailSection: some View {
        VStack(alignment: .leading) {
            
            HStack(spacing: 5) {
                Text("이메일")
                    .font(.headline)
                Image("RequireStar")
                    .resizable()
                    .frame(width: 15, height: 15)
                
            }
            .padding(.horizontal)
            
            HStack {
                TextField("이메일을 입력해주세요", text: $signupVM.email)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.gray)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
            
            if signupVM.emailValidCheck == false {
                Text("잘못된 이메일 양식입니다")
                    .padding(.horizontal)
                    .foregroundColor(Color.red)
            }
            
        }
    }
    
    // MARK: - 획원가입 완료 버튼 섹션
    var signupButton: some View {
        NavigationLink {
            Text("haha")
        } label: {
            if signupVM.signupReadyComplete == true {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 70)
                    .overlay(
                        Text("시작하기")
                            .foregroundColor(.white)
                            .font(.headline)
                    )
                    .onTapGesture {
                        signupVM.signup()
                    }
            } else {
                EmptyView()
            }
        }
    }
    
    
}

//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}
