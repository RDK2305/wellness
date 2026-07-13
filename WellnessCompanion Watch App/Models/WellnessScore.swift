//
//  WellnessScore.swift
//  WellnessCompanion Watch App
//
//  ADVANCED REQUIREMENT — Option A: Wellness Score System.
//  Combines three HealthKit metrics into a single 0-100 score so the user
//  gets one clear, glanceable read on how their day is going.
//  Author: Raman Kumari
//

import Foundation

enum WellnessCategory: String {
    case needsImprovement = "Needs Improvement"
    case moderate = "Moderate Activity"
    case excellent = "Excellent Activity"

    var range: ClosedRange<Int> {
        switch self {
        case .needsImprovement: return 0...40
        case .moderate: return 41...70
        case .excellent: return 71...100
        }
    }

    var tint: String {
        switch self {
        case .needsImprovement: return "red"
        case .moderate: return "orange"
        case .excellent: return "green"
        }
    }

    var encouragement: String {
        switch self {
        case .needsImprovement:
            return "A short walk now will start moving this score up."
        case .moderate:
            return "Solid activity today — a bit more movement gets you to Excellent."
        case .excellent:
            return "Outstanding! You're hitting your wellness goals today."
        }
    }
}

struct WellnessScore {

    /// Weighted blend of steps (50%), active energy (30%) and exercise
    /// minutes (20%) — steps are weighted highest because they are the
    /// most consistently available HealthKit metric on-device.
    let value: Int
    let category: WellnessCategory

    init(metrics: WellnessMetrics) {
        let weighted = (metrics.stepProgress * 0.5)
            + (metrics.activeEnergyProgress * 0.3)
            + (metrics.exerciseProgress * 0.2)

        let score = Int((weighted * 100).rounded())
        self.value = min(max(score, 0), 100)

        switch self.value {
        case 0...40:
            self.category = .needsImprovement
        case 41...70:
            self.category = .moderate
        default:
            self.category = .excellent
        }
    }
}
