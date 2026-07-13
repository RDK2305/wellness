//
//  InsightsView.swift
//  WellnessCompanion Watch App
//
//  SCREEN 2 — Wellness Insights.
//  Explains what the metric means, interprets today's numbers in plain
//  language, and suggests a concrete next activity.
//  Author: Raman Kumari
//

import SwiftUI

struct InsightsView: View {
    @EnvironmentObject private var healthKit: HealthKitManager

    private var metrics: WellnessMetrics { healthKit.metrics }
    private var score: WellnessScore { WellnessScore(metrics: metrics) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {

                InsightSection(
                    icon: "figure.walk",
                    tint: .green,
                    title: "What steps measure",
                    message: "Step count estimates how much you've walked today, using your wrist's motion sensors."
                )

                InsightSection(
                    icon: "percent",
                    tint: .blue,
                    title: "Today's interpretation",
                    message: "You are \(Int(metrics.stepProgress * 100))% toward your daily goal of \(Int(WellnessMetrics.stepGoal)) steps."
                )

                InsightSection(
                    icon: "bolt.heart",
                    tint: .pink,
                    title: "Wellness score",
                    message: "Your combined score is \(score.value)/100 — \(score.category.rawValue). \(score.category.encouragement)"
                )

                InsightSection(
                    icon: "lightbulb",
                    tint: .orange,
                    title: "Suggested activity",
                    message: metrics.suggestedActivityMessage
                )
            }
            .padding(.horizontal, 4)
        }
        .navigationTitle("Insights")
    }
}

private struct InsightSection: View {
    let icon: String
    let tint: Color
    let title: String
    let message: String

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Label(title, systemImage: icon)
                .font(.system(.footnote, design: .rounded, weight: .bold))
                .foregroundStyle(tint)
            Text(message)
                .font(.caption2)
                .foregroundStyle(.primary)
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(tint.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    NavigationStack {
        InsightsView()
    }
    .environmentObject({
        let manager = HealthKitManager()
        manager.authorizationState = .authorized
        manager.metrics = WellnessMetrics(steps: 7450, activeEnergy: 320, exerciseMinutes: 22)
        return manager
    }())
}
