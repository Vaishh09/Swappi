//
//  SettingsPage.swift
//  Swappi
//
//  Created by Asmi Kachare on 3/29/25.
//

import SwiftUI

struct SettingsPage: View {
    @State private var notificationsEnabled = true
    @State private var darkMode = false

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Text("Settings")
                        .font(.system(size: 28, weight: .bold))
                        .padding(.top, 30)
                    Spacer()
                }

                ScrollView {
                    VStack(spacing: 20) {
                        SettingsRow(title: "Edit Profile", icon: "person.crop.circle") {
                        }

                        ToggleRow(title: "Push Notifications", icon: "bell.fill", isOn: $notificationsEnabled)

                        ToggleRow(title: "Dark Mode", icon: "moon.fill", isOn: $darkMode)

                        SettingsRow(title: "Log Out", icon: "arrow.backward.circle.fill", isDestructive: true) {
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .background(Color(red: 0.98, green: 0.98, blue: 1.0).ignoresSafeArea())
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    var isDestructive: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .foregroundColor(isDestructive ? .red : .blue)
                    .font(.system(size: 20))

                Text(title)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(isDestructive ? .red : .primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.system(size: 15))
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
}

struct ToggleRow: View {
    let title: String
    let icon: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.system(size: 20))

            Text(title)
                .font(.system(size: 17, weight: .medium))

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview
{
    SettingsPage();
}
