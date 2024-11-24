//
//  PrivacySettingsView.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar (TA) on 11/23/24.
//
import SwiftUI

struct PrivacySettingsView: View {
    @StateObject private var viewModel = PrivacySettingsViewModel()
    
    var body: some View {
        Form {
            Section(header: Text("Data Cloud Connector")) {
                Toggle(isOn: $viewModel.isDataCollectionEnabled) {
                    VStack(alignment: .leading) {
                        Text("Data Cloud Attributes")
                            .font(.body)
                        if viewModel.isDataCollectionEnabled {
                            Button("Get Token") {
                                viewModel.fetchToken()
                            }
                            .foregroundColor(.blue)
                            .padding(.top, 4)
                        }
                    }
                }
            }
            
            if let token = viewModel.token {
                Section(header: Text("TOKEN INFORMATION")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Access Token: \(token.accessToken)")
                        Text("Expires In: \(token.expiresIn)")
                        Text("Instance URL: \(token.instanceUrl)")
                        Text("Token Type: \(token.tokenType)")
                    }
                    .font(.caption)
                }
            }
            
            if let error = viewModel.errorMessage {
                Section {
                    Text(error)
                        .foregroundColor(.red)
                }
            }
        }
    }
}
