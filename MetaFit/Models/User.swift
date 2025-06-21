import Foundation
import CoreData

struct User: Identifiable, Codable {
    var id = UUID()
    var name: String
    var age: Int
    var height: Double // in cm
    var weight: Double // in kg
    var unitSystem: UnitSystem
    var xpPoints: Int
    var level: Int
    var totalWorkouts: Int
    var totalCaloriesBurned: Double
    var dateCreated: Date
    var lastWorkoutDate: Date?
    
    init(name: String, age: Int, height: Double, weight: Double, unitSystem: UnitSystem = .metric) {
        self.name = name
        self.age = age
        self.height = height
        self.weight = weight
        self.unitSystem = unitSystem
        self.xpPoints = 0
        self.level = 1
        self.totalWorkouts = 0
        self.totalCaloriesBurned = 0
        self.dateCreated = Date()
        self.lastWorkoutDate = nil
    }
    
    var bmi: Double {
        let heightInMeters = height / 100
        return weight / (heightInMeters * heightInMeters)
    }
    
    var bmiCategory: String {
        switch bmi {
        case ..<18.5:
            return "Underweight"
        case 18.5..<25:
            return "Normal"
        case 25..<30:
            return "Overweight"
        default:
            return "Obese"
        }
    }
    
    var xpToNextLevel: Int {
        return level * 100
    }
    
    var progressToNextLevel: Double {
        let xpForCurrentLevel = (level - 1) * 100
        let xpInCurrentLevel = xpPoints - xpForCurrentLevel
        return Double(xpInCurrentLevel) / Double(xpToNextLevel)
    }
} 
