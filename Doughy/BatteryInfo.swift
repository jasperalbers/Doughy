//
//  BatteryInfo.swift
//  Doughy
//
//  Created by Jasper on 20.05.24.
//

import Foundation

class BatteryInfo: ObservableObject {
    @Published var percentage: Int = 0
    @Published var status: String = "Unknown"
    @Published var screenTime: Double = 0.0
    @Published var timeRemaining: String = "Unkown"
    
    private var timer: Timer?

    init() {
        startTimer()
    }

    deinit {
        timer?.invalidate()
    }

    private func startTimer() {
        self.update()
        
        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { _ in
            self.update()
        }
    }
    
    var batteryIcon: String {
        switch percentage {
        case 0...10:
            return status == "Battery" ? "battery.0percent" : "battery.100percent.bolt"
        case 11...35:
            return status == "Battery" ? "battery.25percent" : "battery.100percent.bolt"
        case 36...60:
            return status == "Battery" ? "battery.50percent" : "battery.100percent.bolt"
        case 61...85:
            return status == "Battery" ? "battery.75percent" : "battery.100percent.bolt"
        case 86...100:
            return status == "Battery" ? "battery.100percent" : "battery.100percent.bolt"
        default:
            return status == "Battery" ? "battery.100percent" : "battery.100percent.bolt"
        }
    }
    
    func convertToHoursAndMinutes(from hours: Double) -> String {
        // Separate the whole hours from the fractional part
        let wholeHours = Int(hours)
        let fractionalPart = hours - Double(wholeHours)
        
        // Convert the fractional part to minutes
        let minutes = Int(fractionalPart * 60)
        
        // Format the result into "x hours y minutes"
        let formattedString =  wholeHours > 0 ? "\(wholeHours) hours \(minutes) minutes" : "\(minutes) minutes"
        
        return formattedString
    }

    func update() {
        guard let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue() else { return }
        guard let sources = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue() as? [CFTypeRef] else { return }
        
        for ps in sources {
            if let info = IOPSGetPowerSourceDescription(snapshot, ps)?.takeUnretainedValue() as? [String: Any] {
                if let capacity = info[kIOPSCurrentCapacityKey as String] as? Int,
                   let maxCapacity = info[kIOPSMaxCapacityKey as String] as? Int,
                   let isCharging = info[kIOPSIsChargingKey as String] as? Bool,
                   let timeToEmpty = info[kIOPSTimeToEmptyKey as String] as? Int,
                   let timeToFull = info[kIOPSTimeToFullChargeKey as String] as? Int {
                    
                    percentage = (capacity * 100) / maxCapacity
                    status = isCharging ? "Power Adapter" : "Battery"
                    timeRemaining = isCharging ? convertToHoursAndMinutes(from: Double(timeToFull) / 60.0) : convertToHoursAndMinutes(from: Double(timeToEmpty) / 60.0)
                    if timeRemaining == "-1 minutes" {
                        timeRemaining = "Calculating"
                    }
                }
            }
        }
    }
}
