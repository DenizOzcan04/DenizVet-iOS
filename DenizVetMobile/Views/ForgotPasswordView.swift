//
//  ForgotPasswordView.swift
//  DenizVetMobile
//
//  Created by Deniz Özcan on 12.01.2026.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @State private var phoneNumber: String = ""
    var body: some View {
        ZStack{
            BackgroundForgotPasswordView()
            
            VStack(spacing: 56){
                
                Text("Telefonunuza gelen tek kullanımlık şifre ile giriş yapabilirsiniz.")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 20, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 60)
         
                TextField("Telefon numarası", text: $phoneNumber)
                    .keyboardType(.phonePad)
                    .textContentType(.telephoneNumber)
                    .padding(.horizontal, 100)
                    .frame(height: 52)
                    .frame(maxWidth: 350)
                    .background(.white.opacity(0.78))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(.white.opacity(0.24), lineWidth: 1)
                    )
                    .foregroundStyle(.black)
                    .tint(.black)
                    .padding(.horizontal, 14)
                    .padding(.bottom, 30)

                 CodeCardsView()
                
                 LoginButtonForgotPageView()
                
            }
            .customBackButton()
            
        }
    }
}

@ViewBuilder
func BackgroundForgotPasswordView() -> some View {
    Image("LoginBackground")
        .resizable()
        .scaledToFill()
        .ignoresSafeArea()

    LinearGradient(
        colors: [
            Color.black.opacity(0.55),
            Color.black.opacity(0.20),
            Color.black.opacity(0.55)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    .ignoresSafeArea()

    Color(red: 0.96, green: 0.62, blue: 0.35)
        .opacity(0.12)
        .ignoresSafeArea()
}

@ViewBuilder
func CodeCardsView() -> some View{
    CodeCards()
}

struct CodeCards: View {
    @State private var otp: [String] = Array(repeating: "", count: 6)
    @FocusState private var focusedIndex: Int?
    
    var body: some View {
        HStack(spacing:12){
            
            ForEach(0..<6, id: \.self) {index in
                
                TextField("", text: $otp[index])
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 22, weight: .semibold))
                    .frame(width: 46, height: 54)
                    .background(.white.opacity(0.78))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(
                                focusedIndex == index ? .white.opacity(0.7) : .white.opacity(0.24),
                                lineWidth: 1
                            )
                    )
                    .foregroundStyle(.black)
                    .tint(.black)
                    .focused($focusedIndex, equals: index)
                    .onTapGesture {
                        focusedIndex = index
                    }
                    .onChange(of: otp[index]) { oldValue, newValue in
                        let filtered = newValue.filter { $0.isNumber }
                        if filtered.isEmpty {
                            otp[index] = ""
                            if index > 0 {
                                focusedIndex = index - 1
                            }
                            return
                        }
                        otp[index] = String(filtered.suffix(1))
                        if index < 5 {
                            focusedIndex = index + 1
                        } else {
                            focusedIndex = nil
                        }
                        
                    }
            }
            
        }
        .onAppear{
            focusedIndex = 0
        }
    }
}

@ViewBuilder
func LoginButtonForgotPageView() -> some View {
    Button {
       
    } label: {
        Rectangle()
            .frame(width: 340, height: 54)
            .foregroundStyle(.clear)
            .background(Color(red: 0.96, green: 0.58, blue: 0.18))
            .cornerRadius(18)
            .shadow(color: .black.opacity(0.18), radius: 18, x: 0, y: 12)
            .overlay{
                HStack{
                    
                        Text("Giriş Yap")
                            .foregroundStyle(.white)
                            .font(GilroyFont(isBold: true, size: 20))
                            .padding(.leading, 16)
                    

                    Spacer()

                    Image(systemName: "arrowshape.right.circle.fill")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundStyle(.white.opacity(0.95))
                        .padding(.trailing, 16)
                }
            }
    }
}



#Preview {
    ForgotPasswordView()
}
