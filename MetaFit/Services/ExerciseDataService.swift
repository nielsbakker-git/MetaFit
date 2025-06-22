import Foundation

class ExerciseDataService: ObservableObject {
    @Published var exercises: [Exercise] = []
    
    init() {
        self.exercises = loadGeneratedExercises()
    }
    
    func getExercisesByCategory(_ category: ExerciseCategory) -> [Exercise] {
        return exercises.filter { $0.category == category }
    }
    
    func getExercisesByMuscleGroup(_ muscleGroup: MuscleGroup) -> [Exercise] {
        return exercises.filter { $0.primaryMuscles.contains(muscleGroup) }
    }
    
    func getExercisesByEquipment(_ equipment: Equipment) -> [Exercise] {
        return exercises.filter { $0.equipment == equipment }
    }
    
    func searchExercises(query: String) -> [Exercise] {
        let lowercasedQuery = query.lowercased()
        return exercises.filter { exercise in
            exercise.name.lowercased().contains(lowercasedQuery) ||
            exercise.description.lowercased().contains(lowercasedQuery) ||
            exercise.primaryMuscles.contains { $0.rawValue.lowercased().contains(lowercasedQuery) }
        }
    }
    
    // XP calculation algorithm based on age and calories burned
    func calculateXPForWorkout(workout: Workout, userAge: Int) -> Int {
        var xp = Int(workout.totalCaloriesBurned * 0.1) // Base XP from calories
        
        // Age bonus: older users get more XP for the same effort
        let ageBonus = max(1.0, Double(userAge - 18) * 0.02) // 2% bonus per year over 18
        xp = Int(Double(xp) * ageBonus)
        
        // Duration bonus
        xp += Int(workout.totalDuration / 60) * 2 // 2 XP per minute
        
        // Exercise variety bonus
        let muscleGroups = Set(workout.exercises.flatMap { $0.exercise.primaryMuscles })
        xp += muscleGroups.count * 3
        
        // Difficulty bonus
        let difficultyBonus = workout.exercises.reduce(0) { total, exercise in
            total + getDifficultyMultiplier(exercise.exercise.difficulty)
        }
        xp += difficultyBonus
        
        return max(1, xp) // Minimum 1 XP
    }
    
    private func getDifficultyMultiplier(_ difficulty: Difficulty) -> Int {
        switch difficulty {
        case .beginner:
            return 1
        case .intermediate:
            return 2
        case .advanced:
            return 3
        case .expert:
            return 4
        }
    }
} 