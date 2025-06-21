import Foundation

struct Workout: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var name: String
    var exercises: [WorkoutExercise]
    var totalDuration: TimeInterval
    var totalCaloriesBurned: Double
    var xpEarned: Int
    var notes: String?
    
    init(name: String, date: Date = Date()) {
        self.name = name
        self.date = date
        self.exercises = []
        self.totalDuration = 0
        self.totalCaloriesBurned = 0
        self.xpEarned = 0
        self.notes = nil
    }
    
    mutating func addExercise(_ exercise: WorkoutExercise) {
        exercises.append(exercise)
        recalculateTotals()
    }
    
    mutating func recalculateTotals() {
        totalDuration = exercises.reduce(0) { $0 + $1.totalDuration }
        totalCaloriesBurned = exercises.reduce(0) { $0 + $1.totalCaloriesBurned }
        xpEarned = calculateXP()
    }
    
    private func calculateXP() -> Int {
        // Base XP from calories burned
        var xp = Int(totalCaloriesBurned * 0.1)
        
        // Bonus XP for workout duration (longer workouts = more XP)
        xp += Int(totalDuration / 60) * 2 // 2 XP per minute
        
        // Bonus XP for number of exercises
        xp += exercises.count * 5
        
        // Bonus XP for variety (different muscle groups)
        let muscleGroups = Set(exercises.flatMap { $0.exercise.primaryMuscles })
        xp += muscleGroups.count * 3
        
        return max(1, xp) // Minimum 1 XP
    }
}

struct WorkoutExercise: Identifiable, Codable {
    var id = UUID()
    var exercise: Exercise
    var sets: [ExerciseSet]
    var duration: TimeInterval? // For endurance exercises
    var notes: String?
    
    init(exercise: Exercise) {
        self.exercise = exercise
        self.sets = []
        self.duration = nil
        self.notes = nil
    }
    
    var totalDuration: TimeInterval {
        if let duration = duration {
            return duration
        } else {
            // Estimate duration based on sets and rest time
            let exerciseTime = sets.reduce(0) { $0 + $1.duration }
            let restTime = max(0, Double(sets.count - 1) * 60) // 1 minute rest between sets
            return exerciseTime + restTime
        }
    }
    
    var totalCaloriesBurned: Double {
        if let duration = duration {
            // Endurance exercise
            return exercise.calculateCaloriesBurned(
                duration: duration,
                weight: 70, // Default weight, should be passed from user
                userAge: 30 // Default age, should be passed from user
            )
        } else {
            // Strength exercise
            return sets.reduce(0) { total, set in
                total + exercise.calculateCaloriesBurned(
                    duration: set.duration,
                    weight: 70, // Default weight, should be passed from user
                    userAge: 30, // Default age, should be passed from user
                    exerciseWeight: set.weight
                )
            }
        }
    }
}

struct ExerciseSet: Identifiable, Codable {
    var id = UUID()
    var reps: Int?
    var weight: Double // in kg
    var duration: TimeInterval // in seconds
    var distance: Double? // in meters, for cardio
    var restTime: TimeInterval // in seconds
    
    init(reps: Int? = nil, weight: Double = 0, duration: TimeInterval = 0, distance: Double? = nil, restTime: TimeInterval = 60) {
        self.reps = reps
        self.weight = weight
        self.duration = duration
        self.distance = distance
        self.restTime = restTime
    }
} 
