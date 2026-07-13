//
//  AboutHealthDataView.swift
//  WellnessCompanion Watch App
//
//  SCREEN 3 — About Health Data.
//  Explains where the app's data comes from, what permission was
//  requested and why, and states the app's privacy stance.
//  Author: Raman Kumari
//

import SwiftUI

struct AboutHealthDataView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {

                InfoBlock(
                    icon: "heart.fill",
                    tint: .red,
                    title: "Data Source",
                    message: "All wellness figures come directly from Apple HealthKit on your Apple Watch — steps, active energy, and exercise minutes recorded by the device's sensors."
                )

                InfoBlock(
                    icon: "checkmark.shield",
                    tint: .blue,
                    title: "Why We Ask Permission",
                    message: "This app requests read-only access to the minimum HealthKit metrics needed to show your dashboard and calculate your wellness score. It never requests write access."
                )

                InfoBlock(
                    icon: "lock.shield",
                    tint: .purple,
                    title: "Privacy Statement",
                    message: "Your health data stays on your device. It is never stored on external servers, shared with third parties, or used for advertising."
                )

                InfoBlock(
                    icon: "gearshape",
                    tint: .gray,
                    title: "Manage Permissions",
                    message: "You can review or revoke access anytime in the Health app under Privacy > Apps."
                )
            }
            .padding(.horizontal, 4)
        }
        .navigationTitle("Health Data")
    }
}

private struct InfoBlock: View {
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
        AboutHealthDataView()
    }
}
