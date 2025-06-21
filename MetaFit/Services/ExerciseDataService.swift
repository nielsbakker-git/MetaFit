import Foundation

class ExerciseDataService: ObservableObject {
    @Published var exercises: [Exercise] = []
    
    init() {
        loadExercises()
    }
    
    private func loadExercises() {
        // Predefined exercises based on fitnessprogramer.com
        exercises = [
            // Strength Exercises
            Exercise(
                name: "Bench Press",
                category: .strength,
                equipment: .barbell,
                difficulty: .intermediate,
                primaryMuscles: [.chest, .triceps, .shoulders],
                description: "A compound exercise that primarily targets the chest muscles using a barbell.",
                instructions: [
                    "Lie on a flat bench with your feet planted firmly on the ground",
                    "Grip the barbell slightly wider than shoulder width",
                    "Lower the bar to your chest with control",
                    "Press the bar back up to the starting position"
                ],
                baseCaloriesPerMinute: 8.0,
                weightMultiplier: 0.15
            ),
            
            Exercise(
                name: "Squat",
                category: .strength,
                equipment: .barbell,
                difficulty: .intermediate,
                primaryMuscles: [.legs, .hips, .core],
                description: "A fundamental lower body exercise that targets multiple muscle groups.",
                instructions: [
                    "Place the barbell on your upper back",
                    "Stand with feet shoulder-width apart",
                    "Lower your body by bending at the knees and hips",
                    "Keep your chest up and back straight",
                    "Return to standing position"
                ],
                baseCaloriesPerMinute: 10.0,
                weightMultiplier: 0.2
            ),
            
            Exercise(
                name: "Deadlift",
                category: .strength,
                equipment: .barbell,
                difficulty: .advanced,
                primaryMuscles: [.back, .erectorSpinae, .legs, .hips],
                description: "A compound exercise that targets the posterior chain.",
                instructions: [
                    "Stand with feet hip-width apart",
                    "Bend at the hips and knees to grasp the bar",
                    "Keep your back straight and chest up",
                    "Lift the bar by extending your hips and knees",
                    "Return the bar to the ground with control"
                ],
                baseCaloriesPerMinute: 12.0,
                weightMultiplier: 0.25
            ),
            
            Exercise(
                name: "Pull-ups",
                category: .strength,
                equipment: .noEquipment,
                difficulty: .intermediate,
                primaryMuscles: [.back, .biceps],
                description: "A bodyweight exercise that targets the upper back and arms.",
                instructions: [
                    "Hang from a pull-up bar with hands shoulder-width apart",
                    "Pull your body up until your chin is over the bar",
                    "Lower yourself back down with control",
                    "Repeat for desired number of reps"
                ],
                baseCaloriesPerMinute: 6.0,
                weightMultiplier: 0.1
            ),
            
            Exercise(
                name: "Push-ups",
                category: .strength,
                equipment: .noEquipment,
                difficulty: .beginner,
                primaryMuscles: [.chest, .triceps, .shoulders],
                description: "A classic bodyweight exercise for upper body strength.",
                instructions: [
                    "Start in a plank position with hands shoulder-width apart",
                    "Lower your body until your chest nearly touches the ground",
                    "Push back up to the starting position",
                    "Keep your body in a straight line throughout"
                ],
                baseCaloriesPerMinute: 5.0,
                weightMultiplier: 0.05
            ),
            
            // Cardio Exercises
            Exercise(
                name: "Running",
                category: .cardio,
                equipment: .noEquipment,
                difficulty: .beginner,
                primaryMuscles: [.legs, .calves, .fullBody],
                description: "A high-intensity cardiovascular exercise.",
                instructions: [
                    "Start with a light warm-up",
                    "Maintain good posture with shoulders relaxed",
                    "Land mid-foot and roll through to your toes",
                    "Keep a steady breathing rhythm"
                ],
                baseCaloriesPerMinute: 15.0
            ),
            
            Exercise(
                name: "Cycling",
                category: .cardio,
                equipment: .machine,
                difficulty: .beginner,
                primaryMuscles: [.legs, .calves],
                description: "Low-impact cardiovascular exercise on a stationary bike.",
                instructions: [
                    "Adjust the seat height to your comfort",
                    "Start with a moderate resistance",
                    "Maintain a steady pedaling rhythm",
                    "Keep your core engaged throughout"
                ],
                baseCaloriesPerMinute: 12.0
            ),
            
            Exercise(
                name: "Jump Rope",
                category: .cardio,
                equipment: .noEquipment,
                difficulty: .intermediate,
                primaryMuscles: [.calves, .legs, .fullBody],
                description: "A high-intensity cardio exercise that improves coordination.",
                instructions: [
                    "Hold the rope handles at hip level",
                    "Jump with both feet together",
                    "Keep your elbows close to your body",
                    "Maintain a steady rhythm"
                ],
                baseCaloriesPerMinute: 18.0
            ),
            
            // Core Exercises
            Exercise(
                name: "Plank",
                category: .strength,
                equipment: .noEquipment,
                difficulty: .beginner,
                primaryMuscles: [.core, .abs],
                description: "An isometric exercise that strengthens the core.",
                instructions: [
                    "Start in a forearm plank position",
                    "Keep your body in a straight line",
                    "Engage your core muscles",
                    "Hold the position for the desired time"
                ],
                baseCaloriesPerMinute: 3.0
            ),
            
            Exercise(
                name: "Crunches",
                category: .strength,
                equipment: .noEquipment,
                difficulty: .beginner,
                primaryMuscles: [.abs],
                description: "A classic abdominal exercise.",
                instructions: [
                    "Lie on your back with knees bent",
                    "Place your hands behind your head",
                    "Lift your shoulders off the ground",
                    "Lower back down with control"
                ],
                baseCaloriesPerMinute: 4.0
            ),
            
            // Flexibility Exercises
            Exercise(
                name: "Stretching",
                category: .flexibility,
                equipment: .noEquipment,
                difficulty: .beginner,
                primaryMuscles: [.fullBody],
                description: "General stretching to improve flexibility.",
                instructions: [
                    "Hold each stretch for 15-30 seconds",
                    "Don't bounce during stretches",
                    "Breathe deeply and relax into each stretch",
                    "Stop if you feel pain"
                ],
                baseCaloriesPerMinute: 2.0
            )
        ]
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