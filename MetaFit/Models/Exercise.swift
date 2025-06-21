import Foundation

struct Exercise: Identifiable, Codable {
    var id = UUID()
    var name: String
    var category: ExerciseCategory
    var equipment: Equipment
    var difficulty: Difficulty
    var primaryMuscles: [MuscleGroup]
    var description: String
    var instructions: [String]
    var imageURL: String?
    
    // Calorie calculation properties
    var baseCaloriesPerMinute: Double // Base calories burned per minute
    var weightMultiplier: Double // Multiplier for weight-based exercises
    var ageMultiplier: Double // Multiplier based on age
    
    init(name: String, category: ExerciseCategory, equipment: Equipment, difficulty: Difficulty, 
         primaryMuscles: [MuscleGroup], description: String, instructions: [String], 
         baseCaloriesPerMinute: Double, weightMultiplier: Double = 1.0, ageMultiplier: Double = 1.0) {
        self.name = name
        self.category = category
        self.equipment = equipment
        self.difficulty = difficulty
        self.primaryMuscles = primaryMuscles
        self.description = description
        self.instructions = instructions
        self.baseCaloriesPerMinute = baseCaloriesPerMinute
        self.weightMultiplier = weightMultiplier
        self.ageMultiplier = ageMultiplier
    }
    
    func calculateCaloriesBurned(duration: TimeInterval, weight: Double, userAge: Int, exerciseWeight: Double = 0) -> Double {
        let minutes = duration / 60
        
        // Base calories
        var calories = baseCaloriesPerMinute * minutes
        
        // Adjust for weight being lifted (for strength exercises)
        if exerciseWeight > 0 {
            calories += (exerciseWeight * weightMultiplier * minutes)
        }
        
        // Adjust for user's body weight
        calories += (weight * 0.1 * minutes)
        
        // Adjust for age (older users burn slightly fewer calories)
        let ageFactor = max(0.7, 1.0 - (Double(userAge - 25) * 0.005))
        calories *= ageFactor
        
        return calories
    }
}

enum ExerciseCategory: String, CaseIterable, Codable {
    case strength = "Strength"
    case cardio = "Cardio"
    case flexibility = "Flexibility"
    case balance = "Balance"
    case calisthenics = "Calisthenics"
    case yoga = "Yoga"
    case pilates = "Pilates"
    case plyometrics = "Plyometrics"
    case stretching = "Stretching"
}

enum Equipment: String, CaseIterable, Codable {
    case noEquipment = "No Equipment"
    case barbell = "Barbell"
    case dumbbells = "Dumbbells"
    case bench = "Bench"
    case cable = "Cable"
    case machine = "Machine"
    case kettlebell = "Kettlebell"
    case resistanceBand = "Resistance Band"
    case exerciseBall = "Exercise Ball"
    case foamRoller = "Foam Roller"
    case trx = "TRX Suspension"
    case fullGym = "Full Gym"
}

enum Difficulty: String, CaseIterable, Codable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case expert = "Expert"
}

enum MuscleGroup: String, CaseIterable, Codable {
    case neck = "Neck"
    case trapezius = "Trapezius"
    case shoulders = "Shoulders"
    case chest = "Chest"
    case back = "Back"
    case erectorSpinae = "Erector Spinae"
    case biceps = "Biceps"
    case triceps = "Triceps"
    case forearm = "Forearm"
    case abs = "Abs"
    case core = "Core"
    case legs = "Legs"
    case calves = "Calves"
    case hips = "Hips"
    case fullBody = "Full Body"
} 
