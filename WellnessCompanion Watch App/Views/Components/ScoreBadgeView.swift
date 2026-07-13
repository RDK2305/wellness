//
//  ScoreBadgeView.swift
//  WellnessCompanion Watch App
//
//  Small pill badge used to surface the Wellness Score (Advanced
//  Requirement — Option A) at a glance on the Dashboard.
//  Author: Raman Kumari
//

import SwiftUI

struct ScoreBadgeView: View {
    let score: WellnessScore

    private var color: Color {
        switch score.category {
        case .needsImprovement: return .red
        case .moderate: return .orange
        case .excellent: return .green
        }
    }

    var body: some View {
        HStack(spacing: 6) {
            Text("\(score.value)")
                .font(.system(.title3, design: .rounded, weight: .heavy))
            Text(score.category.rawValue)
                .font(.system(.caption2, design: .rounded, weight: .semibold))
                .multilineTextAlignment(.leading)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(color.opacity(0.2), in: Capsule())
        .foregroundStyle(color)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Wellness score \(score.value) out of 100, \(score.category.rawValue)")
    }
}

#Preview {
    ScoreBadgeView(score: WellnessScore(metrics: WellnessMetrics(steps: 7450, activeEnergy: 320, exerciseMinutes: 22)))
}
