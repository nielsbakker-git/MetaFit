import Foundation

enum UnitSystem: String, CaseIterable, Codable, Hashable {
    case metric = "Metric"
    case imperial = "Imperial"
}

struct UnitConverter {
    // MARK: - Weight Conversion
    
    /// Converts kilograms to pounds.
    static func kgToLbs(_ kg: Double) -> Double {
        return kg * 2.20462
    }
    
    /// Converts pounds to kilograms.
    static func lbsToKg(_ lbs: Double) -> Double {
        return lbs / 2.20462
    }
    
    // MARK: - Height Conversion
    
    /// Converts centimeters to inches.
    static func cmToInches(_ cm: Double) -> Double {
        return cm / 2.54
    }
    
    /// Converts inches to centimeters.
    static func inchesToCm(_ inches: Double) -> Double {
        return inches * 2.54
    }
    
    /// Converts centimeters to feet and inches.
    static func cmToFeetAndInches(_ cm: Double) -> (feet: Int, inches: Double) {
        let totalInches = cmToInches(cm)
        let feet = Int(totalInches / 12)
        let inches = totalInches.truncatingRemainder(dividingBy: 12)
        return (feet, inches)
    }
    
    /// Converts feet and inches to centimeters.
    static func feetAndInchesToCm(feet: Double, inches: Double) -> Double {
        let totalInches = (feet * 12) + inches
        return inchesToCm(totalInches)
    }
    
    // MARK: - Display Strings
    
    /// Formats weight for display based on the selected unit system.
    static func displayWeight(_ kg: Double, in system: UnitSystem) -> String {
        switch system {
        case .metric:
            return String(format: "%.1f kg", kg)
        case .imperial:
            let lbs = kgToLbs(kg)
            return String(format: "%.1f lbs", lbs)
        }
    }
    
    /// Formats height for display based on the selected unit system.
    static func displayHeight(_ cm: Double, in system: UnitSystem) -> String {
        switch system {
        case .metric:
            return String(format: "%.0f cm", cm)
        case .imperial:
            let (feet, inches) = cmToFeetAndInches(cm)
            return "\(feet)' \(String(format: "%.1f", inches))\""
        }
    }
} 