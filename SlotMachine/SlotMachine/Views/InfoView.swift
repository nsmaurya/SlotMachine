//
//  InfoView.swift
//  SlotMachine
//
//  Created by Sunil Maurya on 04/01/24.
//

import SwiftUI

struct InfoView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            LogoView()
            
            Spacer()
            
            Form {
                Section(header: Text("About the application")) {
                    FormRowView(firstItem: "Application", secondItem: "Slot Machine")
                    FormRowView(firstItem: "Platforms", secondItem: "iPhone, iPad, Mac")
                    FormRowView(firstItem: "Developer", secondItem: "Sunil Maurya")
                    FormRowView(firstItem: "Designer", secondItem: "Neha Maurya")
                    FormRowView(firstItem: "Music", secondItem: "Aarav Maurya")
                    FormRowView(firstItem: "Copyright", secondItem: "© 2024 All rights reserved")
                    FormRowView(firstItem: "Version", secondItem: "1.0.0")
                }
            }
            .font(.system(.body, design: .rounded))
        }
        .padding(.top, 50)
        .overlay(
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
                audioPlayer?.stop()
            }, label: {
                Image(systemName: "xmark.circle")
                    .font(.title)
            })
            .padding(.top, 30)
            .padding(.trailing, 20)
            .accentColor(.secondary)
            , alignment: .topTrailing
        )
        .onAppear {
            playSound(sound: "background-music", type: "mp3")
        }
    }
}

struct FormRowView: View {
    var firstItem: String
    var secondItem: String
    var body: some View {
        HStack {
            Text(firstItem)
                .foregroundStyle(.gray)
            Spacer()
            Text(secondItem)
        }
    }
}


#Preview {
    InfoView()
}
