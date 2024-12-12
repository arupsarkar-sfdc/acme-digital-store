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
        ScrollView {
            VStack(spacing: 24) {
                // Profile ID Input Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Enter Profile ID")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        TextField("", text: $viewModel.profileId)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .focused($textfieldFocused)
                            .autocorrectionDisabled()
                            .keyboardType(.default)
                        
                        Button(action: {
                            viewModel.fetchProfile(
                                accessToken: token.accessToken,
                                instanceUrl: token.instanceUrl
                            )
                        }) {
                            Image(systemName: "arrow.clockwise.circle.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                        .disabled(viewModel.profileId.isEmpty)
                    }
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.2)
                        .padding()
                }
                
                // Profile Content
                if let profile = viewModel.profile {
                    ProfileContent(profile: profile)
                }
                
                if let error = viewModel.errorMessage {
                    ErrorView(message: error)
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }
}


struct ProfileContent: View {
    let profile: ProfileData
    
    var body: some View {
        VStack(spacing: 32) {
            // Profile Header
            VStack(spacing: 16) {
                Image("cover-pic")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.blue.opacity(0.2), lineWidth: 4)
                    )
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                
                Text(profile.firstName ?? "User")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            
            // Profile Details
            VStack(spacing: 24) {
                ProfileDetailCard(
                    sections: [
                        ProfileSection(title: "Personal", items: [
                            ProfileItem(icon: "person.fill", title: "Name", value: profile.firstName ?? "N/A"),
                            ProfileItem(icon: "calendar", title: "Birth Date", value: formatDate(profile.birthDate))
                        ]),
                        ProfileSection(title: "Work", items: [
                            ProfileItem(icon: "building.2.fill", title: "Employer", value: profile.currentEmployerName ?? "N/A"),
                            ProfileItem(icon: "number", title: "Account", value: profile.primaryAccountNumber ?? "N/A")
                        ]),
                        ProfileSection(title: "System", items: [
                            ProfileItem(icon: "link", title: "Source ID", value: profile.externalSourceId ?? "N/A"),
                            ProfileItem(icon: "number.square.fill", title: "External ID", value: profile.externalRecordId ?? "N/A")
                        ])
                    ]
                )
            }
        }
    }
    
    private func formatDate(_ dateString: String?) -> String {
        guard let dateString = dateString else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = formatter.date(from: dateString) else { return dateString }
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
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


struct ProfileDetailCard: View {
    let sections: [ProfileSection]
    
    var body: some View {
        VStack(spacing: 24) {
            ForEach(sections, id: \.title) { section in
                VStack(alignment: .leading, spacing: 16) {
                    Text(section.title)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    VStack(spacing: 16) {
                        ForEach(section.items, id: \.title) { item in
                            HStack(spacing: 12) {
                                Image(systemName: item.icon)
                                    .foregroundColor(.blue)
                                    .frame(width: 24)
                                
                                Text(item.title)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text(item.value)
                                    .fontWeight(.medium)
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            }
        }
    }
}

struct ProfileSection {
    let title: String
    let items: [ProfileItem]
}

struct ProfileItem {
    let icon: String
    let title: String
    let value: String
}

struct ErrorView: View {
    let message: String
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.red)
        }
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(8)
    }
}
