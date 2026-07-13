//
//  WellnessMetrics.swift
//  WellnessCompanion Watch App
//
//  Holds the daily HealthKit readings and the goals they are measured
//  against. Kept as a plain model so it can be previewed without HealthKit.
//  Author: Raman Kumari
//

import Foundation

struct WellnessMetrics {

    // MARK: - Daily goals (reasonable, commonly used defaults)

    static let stepGoal: Double = 10_000
    static let activeEnergyGoal: Double = 450        // kilocalories
    static let exerciseMinutesGoal: Double = 30       // minutes

    // MARK: - Live values populated from HealthKit

    var steps: Double = 0
    var activeEnergy: Double = 0
    var exerciseMinutes: Double = 0

    // MARK: - Convenience progress helpers (0.0 ... 1.0)

    var stepProgress: Double {
        min(steps / Self.stepGoal, 1.0)
    }

    var activeEnergyProgress: Double {
        min(activeEnergy / Self.activeEnergyGoal, 1.0)
    }

    var exerciseProgress: Double {
        min(exerciseMinutes / Self.exerciseMinutesGoal, 1.0)
    }

    var stepStatusMessage: String {
        switch stepProgress {
        case 0.75...:
            return "Excellent progress"
        case 0.4..<0.75:
            return "Good progress"
        default:
            return "Just getting started"
        }
    }

    var suggestedActivityMessage: String {
        switch stepProgress {
        case 0.75...:
            return "You're crushing it today — a short cool-down walk will keep the streak going."
        case 0.4..<0.75:
            return "You're over a third of the way there. A 10-minute walk will push you past the halfway mark."
        default:
            return "Every step counts. Try a brisk 5-minute walk to get moving toward today's goal."
        }
    }
}
