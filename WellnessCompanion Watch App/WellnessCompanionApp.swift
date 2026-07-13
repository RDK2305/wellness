//
//  WellnessCompanionApp.swift
//  WellnessCompanion Watch App
//
//  Assignment 3 – Personal Wellness Companion (watchOS)
//  Author: Raman Kumari
//

import SwiftUI

@main
struct WellnessCompanion_Watch_AppApp: App {

    @StateObject private var healthKitManager = HealthKitManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(healthKitManager)
                .task {
                    await healthKitManager.requestAuthorization()
                }
        }
    }
}
