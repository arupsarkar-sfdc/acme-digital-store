//
//  ProfileFormView.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar (TA) on 11/18/24.
//

import SwiftUI
import SFMCSDK

struct ProfileFormView: View {
    @StateObject private var viewModel = ProfileFormViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("First Name", text: $viewModel.firstName)
                        .textContentType(.givenName)
                        .autocapitalization(.words)
                    
                    TextField("Last Name", text: $viewModel.lastName)
                        .textContentType(.familyName)
                        .autocapitalization(.words)
                    
                    TextField("Email", text: $viewModel.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                Button(action: viewModel.submitProfile) {
                    HStack {
                        Spacer()
                        Text("Submit")
                            .bold()
                        Spacer()
                    }
                }
                .disabled(!viewModel.isValid)
            }
            .navigationTitle("Profile")
            .alert("Success", isPresented: $viewModel.showSuccess) {
                Button("OK") { dismiss() }
            } message: {
                Text("Profile updated successfully")
            }
        }
    }
}
