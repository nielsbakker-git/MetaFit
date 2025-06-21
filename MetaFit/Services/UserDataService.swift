import Foundation
import SwiftUI

class UserDataService: ObservableObject {
    @Published var currentUser: User?
    @Published var workouts: [Workout] = []
    
    private let userDefaults = UserDefaults.standard
    private let userKey = "currentUser"
    private let workoutsKey = "userWorkouts"
    
    init() {
        loadUser()
        loadWorkouts()
    }
    
    // MARK: - User Management
    
    func createUser(name: String, age: Int, height: Double, weight: Double, unitSystem: UnitSystem) {
        let user = User(name: name, age: age, height: height, weight: weight, unitSystem: unitSystem)
        currentUser = user
        saveUser()
    }
    
    func updateUser(_ user: User) {
        currentUser = user
        saveUser()
    }
    
    func updateUserSystem(_ system: UnitSystem) {
        guard var user = currentUser else { return }
        user.unitSystem = system
        updateUser(user)
    }
    
    func addXP(_ xp: Int) {
        guard var user = currentUser else { return }
        
        user.xpPoints += xp
        
        // Check for level up
        let newLevel = calculateLevel(xpPoints: user.xpPoints)
        if newLevel > user.level {
            user.level = newLevel
            // Could add level up celebration here
        }
        
        currentUser = user
        saveUser()
    }
    
    private func calculateLevel(xpPoints: Int) -> Int {
        // Level calculation: each level requires level * 100 XP
        // Level 1: 0-99 XP, Level 2: 100-299 XP, Level 3: 300-599 XP, etc.
        var level = 1
        var xpRequired = 0
        
        while xpPoints >= xpRequired {
            level += 1
            xpRequired += level * 100
        }
        
        return level - 1
    }
    
    // MARK: - Workout Management
    
    func addWorkout(_ workout: Workout) {
        workouts.append(workout)
        
        // Update user stats
        if var user = currentUser {
            user.totalWorkouts += 1
            user.totalCaloriesBurned += workout.totalCaloriesBurned
            user.lastWorkoutDate = workout.date
            user.xpPoints += workout.xpEarned
            
            // Check for level up
            let newLevel = calculateLevel(xpPoints: user.xpPoints)
            if newLevel > user.level {
                user.level = newLevel
            }
            
            currentUser = user
            saveUser()
        }
        
        saveWorkouts()
    }
    
    func getWorkoutsForDate(_ date: Date) -> [Workout] {
        let calendar = Calendar.current
        return workouts.filter { workout in
            calendar.isDate(workout.date, inSameDayAs: date)
        }
    }
    
    func getWorkoutsForWeek(containing date: Date) -> [Workout] {
        let calendar = Calendar.current
        let weekStart = calendar.dateInterval(of: .weekOfYear, for: date)?.start ?? date
        let weekEnd = calendar.dateInterval(of: .weekOfYear, for: date)?.end ?? date
        
        return workouts.filter { workout in
            workout.date >= weekStart && workout.date < weekEnd
        }
    }
    
    func getWorkoutsForMonth(containing date: Date) -> [Workout] {
        let calendar = Calendar.current
        let monthStart = calendar.dateInterval(of: .month, for: date)?.start ?? date
        let monthEnd = calendar.dateInterval(of: .month, for: date)?.end ?? date
        
        return workouts.filter { workout in
            workout.date >= monthStart && workout.date < monthEnd
        }
    }
    
    // MARK: - Statistics
    
    func getWeeklyStats() -> (totalWorkouts: Int, totalCalories: Double, totalXP: Int) {
        let weekWorkouts = getWorkoutsForWeek(containing: Date())
        let totalWorkouts = weekWorkouts.count
        let totalCalories = weekWorkouts.reduce(0) { $0 + $1.totalCaloriesBurned }
        let totalXP = weekWorkouts.reduce(0) { $0 + $1.xpEarned }
        
        return (totalWorkouts, totalCalories, totalXP)
    }
    
    func getMonthlyStats() -> (totalWorkouts: Int, totalCalories: Double, totalXP: Int) {
        let monthWorkouts = getWorkoutsForMonth(containing: Date())
        let totalWorkouts = monthWorkouts.count
        let totalCalories = monthWorkouts.reduce(0) { $0 + $1.totalCaloriesBurned }
        let totalXP = monthWorkouts.reduce(0) { $0 + $1.xpEarned }
        
        return (totalWorkouts, totalCalories, totalXP)
    }
    
    func getStreakDays() -> Int {
        guard !workouts.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let sortedWorkouts = workouts.sorted { $0.date > $1.date }
        var streak = 0
        var currentDate = Date()
        
        for workout in sortedWorkouts {
            if calendar.isDate(workout.date, inSameDayAs: currentDate) {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else if calendar.dateInterval(of: .day, for: workout.date)?.start ?? workout.date < calendar.dateInterval(of: .day, for: currentDate)?.start ?? currentDate {
                break
            }
        }
        
        return streak
    }
    
    // MARK: - Persistence
    
    private func saveUser() {
        if let user = currentUser,
           let data = try? JSONEncoder().encode(user) {
            userDefaults.set(data, forKey: userKey)
        }
    }
    
    private func loadUser() {
        if let data = userDefaults.data(forKey: userKey),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            currentUser = user
        }
    }
    
    private func saveWorkouts() {
        if let data = try? JSONEncoder().encode(workouts) {
            userDefaults.set(data, forKey: workoutsKey)
        }
    }
    
    private func loadWorkouts() {
        if let data = userDefaults.data(forKey: workoutsKey),
           let loadedWorkouts = try? JSONDecoder().decode([Workout].self, from: data) {
            workouts = loadedWorkouts
        }
    }
} 