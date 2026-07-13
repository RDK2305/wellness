//
//  ContentView.swift
//  WellnessCompanion Watch App
//
//  Root navigation container for the app.
//  Author: Raman Kumari
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            DashboardView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(HealthKitManager())
}
