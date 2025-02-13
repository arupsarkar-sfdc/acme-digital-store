//
//  ChatView.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar (TA) on 1/27/25.
//

import SwiftUI
import SMIClientCore // For the core classes
import SMIClientUI   // For the UI-related classes

struct ChatView: View {
    
    @State private var uiConfiguration: UIConfiguration?
        
    var body: some View {
        NavigationView {
            VStack {
                if let config = uiConfiguration {
                    Interface(config)
                } else {
                    Text("Loading configuration...")
                }
            }
            .navigationTitle("Agentforce")
            .onAppear {
                loadConfiguration()
            }
        }
    }
    
    private func loadConfiguration() {
        
        // Get the path for the config file
        guard let configPath = Bundle.main.path(forResource: "configFile",
                                                ofType: "json") else {
            // TO DO: Handle error
            return
        }
        
        // Get a URL for the config file
        let configURL = URL(fileURLWithPath: configPath)
        
        // Generate a random conversation ID
        // (But be sure to use the SAME conversation ID if you want
        // to continue this conversation across app restarts or
        // across devices!)
        let conversationID = UUID()
        
        // Create a configuration object
        let config = UIConfiguration(url: configURL, conversationId: conversationID)
        self.uiConfiguration = config
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
