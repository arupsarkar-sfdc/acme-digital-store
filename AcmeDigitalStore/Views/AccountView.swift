//
//  AccountView.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar (TA) on 11/18/24.
//

import SwiftUI


struct AccountView: View {
    @StateObject private var viewModel = PrivacySettingsViewModel()
    @AppStorage("hasConsented") private var hasConsented: Bool = false
    private let logger = DataCloudLoggingService.shared
    @State private var showProfileModal = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Modern Header
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Account")
                            .font(.largeTitle.bold())
                        Text("Manage Your Settings")
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(.primary)
                        Text("Privacy and profile information")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                    // Content Sections
                    VStack(spacing: 20) {
                        // Privacy Section
                        Section {
                            Toggle("Data Collection", isOn: Binding(
                                get: { ConsentService.shared.getCurrentConsent() == .optIn },
                                set: { newValue in
                                    ConsentService.shared.setConsent(isOptedIn: newValue)
                                }
                            ))
                            .tint(.green)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemBackground))
                            )
                        } header: {
                            Text("PRIVACY SETTINGS")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        // MARK: Token Information Section
                        if ConsentService.shared.getCurrentConsent() == .optIn {
                            Section {
                                VStack(alignment: .leading, spacing: 12) {
                                    Button(action: {
                                        viewModel.fetchToken()
                                    }) {
                                        HStack {
                                            Image(systemName: "key.fill")
                                            Text("Get Token")
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                    }
                                    
                                    if let token = viewModel.token {
                                        ScrollView {
                                            VStack(alignment: .leading, spacing: 8) {
                                                TokenInfoRow(title: "Access Token", value: token.accessToken)
                                                TokenInfoRow(title: "Instance URL", value: token.instanceUrl)
                                                TokenInfoRow(title: "Token Type", value: token.tokenType)
                                                TokenInfoRow(title: "Expires In", value: "\(token.expiresIn) seconds")
                                            }
                                        }
                                    }
                                    
                                    if let error = viewModel.errorMessage {
                                        Text(error)
                                            .foregroundColor(.red)
                                            .font(.caption)
                                    }
                                }
                            } header: {
                                Text("TOKEN INFORMATION")
                            }
                        }
                        
                        // MARK: Profile Section
                           if let token = viewModel.token {
                               Section {
                                   Button(action: {
                                       showProfileModal = true
                                   }) {
                                       HStack {
                                           Image(systemName: "person.circle.fill")
                                               .resizable()
                                               .frame(width: 30, height: 30)
                                               .foregroundColor(.blue)
                                           
                                           VStack(alignment: .leading, spacing: 4) {
                                               Text("Profile Information")
                                                   .font(.headline)
                                               Text("Tap to view profile details")
                                                   .font(.caption)
                                                   .foregroundColor(.secondary)
                                           }
                                           Spacer()
                                           Image(systemName: "chevron.right")
                                               .foregroundColor(.gray)
                                       }
                                   }
                               } header: {
                                   Text("PROFILE")
                               }
                               .sheet(isPresented: $showProfileModal) {
                                   NavigationView {
                                       ScrollView {
                                           ProfileCardView(token: token)
                                       }
                                       .navigationTitle("Profile Details")
                                       .navigationBarTitleDisplayMode(.inline)
                                       .toolbar {
                                           ToolbarItem(placement: .navigationBarTrailing) {
                                               Button("Done") {
                                                   showProfileModal = false
                                               }
                                           }
                                       }
                                   }
                               }
                           }
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


struct TokenInfoRow: View {
    let title: String
    let value: String
    
    var displayValue: String {
        if title == "Access Token" {
            let prefix = String(value.prefix(10))
            return "\(prefix)..."
        }
        return value
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(displayValue)
                .font(.caption2)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 4)
    }
}
