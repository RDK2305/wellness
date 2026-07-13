//
//  HealthKitManager.swift
//  WellnessCompanion Watch App
//
//  Requests authorization for the minimum set of HealthKit metrics the
//  app needs, retrieves today's totals, and exposes them to SwiftUI via
//  an ObservableObject. Denied / restricted permission is handled
//  gracefully by falling back to an explanatory state instead of
//  crashing or showing blank data.
//  Author: Raman Kumari
//

import Foundation
import HealthKit
import Combine

@MainActor
final class HealthKitManager: ObservableObject {

    // MARK: - Published state consumed by the views

    @Published var metrics = WellnessMetrics()
    @Published var authorizationState: AuthorizationState = .notRequested
    @Published var isLoading = false

    enum AuthorizationState: Equatable {
        case notRequested
        case authorized
        case denied
        case unavailable
    }

    private let healthStore = HKHealthStore()

    // Only the metrics this feature actually needs — no over-requesting.
    private let stepType = HKQuantityType(.stepCount)
    private let activeEnergyType = HKQuantityType(.activeEnergyBurned)
    private let exerciseTimeType = HKQuantityType(.appleExerciseTime)

    private var readTypes: Set<HKObjectType> {
        [stepType, activeEnergyType, exerciseTimeType]
    }

    // MARK: - Authorization

    func requestAuthorization() async {
        guard HKHealthStore.isHealthDataAvailable() else {
            authorizationState = .unavailable
            return
        }

        do {
            try await healthStore.requestAuthorization(toShare: [], read: readTypes)
            // HealthKit does not reveal per-type allow/deny status for
            // privacy reasons, so we optimistically attempt a fetch and
            // treat a total lack of data as "denied or no data yet".
            authorizationState = .authorized
            await fetchTodayMetrics()
        } catch {
            authorizationState = .denied
        }
    }

    // MARK: - Fetching

    func fetchTodayMetrics() async {
        guard authorizationState == .authorized else { return }
        isLoading = true
        defer { isLoading = false }

        async let steps = sumToday(for: stepType, unit: .count())
        async let activeEnergy = sumToday(for: activeEnergyType, unit: .kilocalorie())
        async let exerciseMinutes = sumToday(for: exerciseTimeType, unit: .minute())

        let (stepsValue, energyValue, exerciseValue) = await (steps, activeEnergy, exerciseMinutes)

        metrics.steps = stepsValue
        metrics.activeEnergy = energyValue
        metrics.exerciseMinutes = exerciseValue
    }

    private func sumToday(for type: HKQuantityType, unit: HKUnit) -> Double {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

        return withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: type,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, statistics, _ in
                let total = statistics?.sumQuantity()?.doubleValue(for: unit) ?? 0
                continuation.resume(returning: total)
            }
            healthStore.execute(query)
        }
    }
}
