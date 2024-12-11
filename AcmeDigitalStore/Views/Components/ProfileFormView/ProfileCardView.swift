//
//  ProfileCardView.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar (TA) on 11/23/24.
//

import SwiftUI

struct ProfileCardView: View {
    @StateObject private var viewModel = ProfileViewModel()
    let token: TokenResponse.Token
    private let logger = DataCloudLoggingService.shared
    @FocusState private var textfieldFocused: Bool
    
    private func formatBirthDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: date)
        }
        return dateString
    }
    
    var body: some View {
        VStack(spacing: 16) {
//            TextField("Enter Profile ID", text: $viewModel.profileId)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding(.horizontal)
//                .onReceive(NotificationCenter.default.publisher(for: UIPasteboard.changedNotification)) { _ in
//                     if let pastedString = UIPasteboard.general.string {
//                         viewModel.profileId = pastedString
//                     }
//                 }
            TextEditor(text: $viewModel.profileId)
                .frame(height: 40)
                .padding(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .autocorrectionDisabled()
                .padding(.horizontal)
                .focused($textfieldFocused)
                            .onLongPressGesture(minimumDuration: 0.0) {
                                textfieldFocused = true
                }
            
            Button(action: {
                viewModel.fetchProfile(
                    accessToken: token.accessToken,
                    instanceUrl: token.instanceUrl
                )
            }) {
                HStack {
                    Image(systemName: "person.circle.fill")
                    Text("Profile Information")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
            }
            .disabled(viewModel.profileId.isEmpty)
            
            if viewModel.isLoading {
                ProgressView()
            }
            
            if let profile = viewModel.profile {
                VStack(spacing: 24) {
                    // Profile Image
                    Image("cover-pic")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                        .shadow(radius: 5)
                    
                    // Profile Details Card
                    VStack(alignment: .leading, spacing: 16) {
                        ProfileDetailRow(title: "First Name", value: profile.firstName ?? "N/A")
                        ProfileDetailRow(title: "Employer", value: profile.currentEmployerName ?? "N/A")
                        ProfileDetailRow(title: "Account", value: profile.primaryAccountNumber ?? "N/A")
                        if let birthDate = profile.birthDate {
                            ProfileDetailRow(title: "Birth Date", value: formatBirthDate(birthDate))
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemBackground))
                            .shadow(color: .gray.opacity(0.2), radius: 8, x: 0, y: 2)
                    )
                }
                .padding()
            }
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .padding()
    }
}


struct ProfileDetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(value)
                .font(.body)
                .fontWeight(.medium)
        }
    }
}
