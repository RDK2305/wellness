//
//  ProgressRingView.swift
//  WellnessCompanion Watch App
//
//  A compact circular progress ring sized for Apple Watch faces —
//  reused on the Dashboard and Insights screens.
//  Author: Raman Kumari
//

import SwiftUI

struct ProgressRingView: View {
    let progress: Double            // 0.0 ... 1.0
    let tint: Color
    var lineWidth: CGFloat = 8

    var body: some View {
        ZStack {
            Circle()
                .stroke(tint.opacity(0.25), lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: max(progress, 0.001))
                .stroke(tint, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 0.6), value: progress)

            Text("\(Int(progress * 100))%")
                .font(.system(.footnote, design: .rounded, weight: .bold))
                .minimumScaleFactor(0.7)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Progress \(Int(progress * 100)) percent")
    }
}

#Preview {
    ProgressRingView(progress: 0.74, tint: .green)
        .frame(width: 80, height: 80)
}
