//
//  AboutYouPage.swift
//  Swappi
//
//  Created by Asmi Kachare on 3/29/25.
//

import SwiftUI

struct AboutYouPage: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 1.0, green: 0.65, blue: 0.9),
                    Color(red: 0.55, green: 0.85, blue: 1.0)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                    }
                    Spacer()
                }
                .padding(.top, 10)
                
                Image("SwappiLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
                Spacer()
                
                Text("Tell us about yourself!")
                    .font(.title)
                    .foregroundColor(.white)
                                
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

struct AboutYouPage_Previews: PreviewProvider {
    static var previews: some View {
        AboutYouPage()
    }
}
