//
//  DashboardView.swift
//  WellnessCompanion Watch App
//
//  SCREEN 1 — Daily Wellness Dashboard.
//  Shows the primary wellness metric, today's progress, current status,
//  and the Wellness Score, then links to the other two screens.
//  Author: Raman Kumari
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var healthKit: HealthKitManager

    private var score: WellnessScore {
        WellnessScore(metrics: healthKit.metrics)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                header

                if healthKit.isLoading {
                    ProgressView()
                        .padding(.top, 20)
                } else {
                    switch healthKit.authorizationState {
                    case .notRequested:
                        ProgressView()
                            .padding(.top, 20)

                    case .authorized:
                        metricCard
                        ScoreBadgeView(score: score)
                            .padding(.top, 2)

                    case .denied:
                        PermissionDeniedCard()

                    case .unavailable:
                        UnavailableCard()
                    }
                }

                navigationLinks
            }
            .padding(.horizontal, 4)
        }
        .navigationTitle("Wellness")
        .task { await healthKit.fetchTodayMetrics() }
    }

    private var header: some View {
        Text("Today's Steps")
            .font(.system(.footnote, design: .rounded, weight: .semibold))
            .foregroundStyle(.secondary)
    }

    private var metricCard: some View {
        VStack(spacing: 6) {
            HStack(spacing: 12) {
                ProgressRingView(progress: healthKit.metrics.stepProgress, tint: .green)
                    .frame(width: 56, height: 56)

                VStack(alignment: .leading, spacing: 2) {
                    Text(healthKit.metrics.steps, format: .number.rounded())
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                    Text("of \(Int(WellnessMetrics.stepGoal)) goal")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            Text(healthKit.metrics.stepStatusMessage)
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                .foregroundStyle(.green)
                .multilineTextAlignment(.center)
                .padding(.top, 2)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(.green.opacity(0.12), in: RoundedRectangle(cornerRadius: 16))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Today's steps: \(Int(healthKit.metrics.steps)) of \(Int(WellnessMetrics.stepGoal)) goal. \(healthKit.metrics.stepStatusMessage).")
    }

    private var navigationLinks: some View {
        VStack(spacing: 6) {
            NavigationLink {
                InsightsView()
            } label: {
                Label("Insights", systemImage: "chart.line.uptrend.xyaxis")
            }
            .accessibilityHint("Open wellness insights and suggested activity")

            NavigationLink {
                AboutHealthDataView()
            } label: {
                Label("Health Data Info", systemImage: "heart.text.square")
            }
            .accessibilityHint("Open health data source and privacy information")
        }
        .padding(.top, 6)
    }
}

private struct PermissionDeniedCard: View {
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: "hand.raised.slash")
                .font(.title2)
                .foregroundStyle(.orange)
            Text("Health data unavailable")
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
            Text("Enable permissions in the Health app to see your wellness data here.")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(10)
        .accessibilityElement(children: .combine)
    }
}

private struct UnavailableCard: View {
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: "exclamationmark.triangle")
                .font(.title2)
                .foregroundStyle(.orange)
            Text("HealthKit isn't available on this device.")
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .padding(10)
    }
}

#Preview {
    NavigationStack {
        DashboardView()
    }
    .environmentObject({
        let manager = HealthKitManager()
        manager.authorizationState = .authorized
        manager.metrics = WellnessMetrics(steps: 7450, activeEnergy: 320, exerciseMinutes: 22)
        return manager
    }())
}
