import SwiftUI

struct WorkoutView: View {
    @EnvironmentObject var userDataService: UserDataService
    @EnvironmentObject var exerciseDataService: ExerciseDataService
    @State private var showingNewWorkout = false
    @State private var showingActiveWorkout = false
    @State private var currentWorkout: Workout?
    
    var body: some View {
        NavigationView {
            VStack {
                if currentWorkout != nil {
                    ActiveWorkoutView(workout: $currentWorkout)
                } else {
                    WorkoutListView(onQuickStart: { workoutName in
                        self.currentWorkout = Workout(name: workoutName)
                    })
                }
            }
            .navigationTitle("Workouts")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingNewWorkout = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewWorkout) {
                NewWorkoutView { workout in
                    currentWorkout = workout
                    showingNewWorkout = false
                }
            }
        }
    }
}

struct WorkoutListView: View {
    @EnvironmentObject var userDataService: UserDataService
    let onQuickStart: (String) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Quick Start Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Quick Start")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 15) {
                        Button(action: { onQuickStart("Strength Workout") }) {
                            QuickStartButton(
                                title: "Strength",
                                subtitle: "Build muscle",
                                icon: "dumbbell.fill",
                                color: .blue
                            )
                        }
                        
                        Button(action: { onQuickStart("Cardio Workout") }) {
                            QuickStartButton(
                                title: "Cardio",
                                subtitle: "Burn calories",
                                icon: "heart.fill",
                                color: .red
                            )
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Today's Workouts
                VStack(alignment: .leading, spacing: 15) {
                    Text("Today's Workouts")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    let todaysWorkouts = userDataService.getWorkoutsForDate(Date())
                    
                    if todaysWorkouts.isEmpty {
                        VStack(spacing: 10) {
                            Image(systemName: "calendar.badge.plus")
                                .font(.title)
                                .foregroundColor(.secondary)
                            Text("No workouts today")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("Start a new workout to begin tracking your fitness journey!")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    } else {
                        ForEach(todaysWorkouts) { workout in
                            WorkoutCardView(workout: workout)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            .padding()
        }
    }
}

struct QuickStartButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct WorkoutCardView: View {
    let workout: Workout
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(workout.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(workout.date, style: .time)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(Int(workout.totalCaloriesBurned)) cal")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text("+\(workout.xpEarned) XP")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            // Exercise summary
            Text("\(workout.exercises.count) exercises • \(Int(workout.totalDuration / 60)) min")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 1)
    }
}

struct NewWorkoutView: View {
    @EnvironmentObject var exerciseDataService: ExerciseDataService
    @Environment(\.dismiss) private var dismiss
    @State private var workoutName = ""
    @State private var selectedExercises: [Exercise] = []
    @State private var showingExercisePicker = false
    
    let onWorkoutCreated: (Workout) -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Workout Name
                VStack(alignment: .leading, spacing: 8) {
                    Text("Workout Name")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    TextField("e.g., Upper Body Strength", text: $workoutName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                // Selected Exercises
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Exercises")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Spacer()
                        
                        Button("Add Exercise") {
                            showingExercisePicker = true
                        }
                        .foregroundColor(.blue)
                    }
                    
                    if selectedExercises.isEmpty {
                        VStack(spacing: 10) {
                            Image(systemName: "plus.circle")
                                .font(.title)
                                .foregroundColor(.secondary)
                            Text("No exercises added")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("Tap 'Add Exercise' to start building your workout")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    } else {
                        ForEach(selectedExercises) { exercise in
                            ExerciseRowView(exercise: exercise)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("New Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Start") {
                        startWorkout()
                    }
                    .disabled(workoutName.isEmpty || selectedExercises.isEmpty)
                }
            }
            .sheet(isPresented: $showingExercisePicker) {
                ExercisePickerView(selectedExercises: $selectedExercises)
            }
        }
    }
    
    private func startWorkout() {
        var workout = Workout(name: workoutName)
        for exercise in selectedExercises {
            workout.addExercise(WorkoutExercise(exercise: exercise))
        }
        onWorkoutCreated(workout)
    }
}

struct ExerciseRowView: View {
    let exercise: Exercise
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(exercise.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(exercise.equipment.rawValue)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

struct ExercisePickerView: View {
    @EnvironmentObject var exerciseDataService: ExerciseDataService
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedExercises: [Exercise]
    @State private var searchText = ""
    @State private var selectedCategory: ExerciseCategory?
    
    var filteredExercises: [Exercise] {
        var exercises = exerciseDataService.exercises
        
        if let category = selectedCategory {
            exercises = exercises.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            exercises = exercises.filter { exercise in
                exercise.name.lowercased().contains(searchText.lowercased()) ||
                exercise.description.lowercased().contains(searchText.lowercased())
            }
        }
        
        return exercises
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search and Filter
                VStack(spacing: 10) {
                    TextField("Search exercises...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            FilterChip(
                                title: "All",
                                isSelected: selectedCategory == nil
                            ) {
                                selectedCategory = nil
                            }
                            
                            ForEach(ExerciseCategory.allCases, id: \.self) { category in
                                FilterChip(
                                    title: category.rawValue,
                                    isSelected: selectedCategory == category
                                ) {
                                    selectedCategory = category
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
                
                // Exercise List
                List(filteredExercises) { exercise in
                    ExercisePickerRowView(
                        exercise: exercise,
                        isSelected: selectedExercises.contains { $0.id == exercise.id }
                    ) {
                        if selectedExercises.contains(where: { $0.id == exercise.id }) {
                            selectedExercises.removeAll { $0.id == exercise.id }
                        } else {
                            selectedExercises.append(exercise)
                        }
                    }
                }
            }
            .navigationTitle("Add Exercises")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(16)
        }
    }
}

struct ExercisePickerRowView: View {
    let exercise: Exercise
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(exercise.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(exercise.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ActiveWorkoutView: View {
    @Binding var workout: Workout?
    @EnvironmentObject var userDataService: UserDataService
    @EnvironmentObject var exerciseDataService: ExerciseDataService
    @State private var currentExerciseIndex = 0
    @State private var showingExerciseDetail = false
    @State private var showingExercisePicker = false
    @State private var exercisesForPicker: [Exercise] = []
    
    var body: some View {
        VStack {
            if let workout = workout {
                // Workout Header
                VStack(spacing: 10) {
                    Text(workout.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("\(workout.exercises.count) exercises")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                
                // Current Exercise
                if !workout.exercises.isEmpty && currentExerciseIndex < workout.exercises.count {
                    let currentExercise = workout.exercises[currentExerciseIndex]
                    
                    VStack(spacing: 20) {
                        Text("Exercise \(currentExerciseIndex + 1) of \(workout.exercises.count)")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        ExerciseDetailCard(exercise: currentExercise.exercise)
                        
                        // Navigation Buttons
                        HStack(spacing: 20) {
                            Button("Previous") {
                                if currentExerciseIndex > 0 {
                                    currentExerciseIndex -= 1
                                }
                            }
                            .disabled(currentExerciseIndex == 0)
                            
                            Button("Next") {
                                if currentExerciseIndex < workout.exercises.count - 1 {
                                    currentExerciseIndex += 1
                                } else {
                                    finishWorkout()
                                }
                            }
                            .foregroundColor(.blue)
                        }
                    }
                    .padding()
                } else {
                    VStack(spacing: 20) {
                        Text("No exercises in this workout")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Button("Add Exercises") {
                            exercisesForPicker = workout.exercises.map { $0.exercise }
                            showingExercisePicker = true
                        }
                        .foregroundColor(.blue)
                    }
                }
                
                Spacer()
                
                // Finish Button
                Button("Finish Workout") {
                    finishWorkout()
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .cornerRadius(10)
                .padding()
            }
        }
        .sheet(isPresented: $showingExercisePicker, onDismiss: {
            if var w = workout {
                let currentExerciseIDs = w.exercises.map { $0.exercise.id }
                let newExercises = exercisesForPicker.filter { !currentExerciseIDs.contains($0.id) }
                
                for exercise in newExercises {
                    w.addExercise(WorkoutExercise(exercise: exercise))
                }
                
                w.exercises.removeAll { exercise in
                    !exercisesForPicker.contains(where: { $0.id == exercise.exercise.id })
                }
                
                workout = w
            }
        }) {
            ExercisePickerView(selectedExercises: $exercisesForPicker)
        }
    }
    
    private func finishWorkout() {
        guard let workout = workout else { return }
        
        // Calculate final stats
        var finalWorkout = workout
        finalWorkout.recalculateTotals()
        
        // Add to user data
        userDataService.addWorkout(finalWorkout)
        
        // Reset
        self.workout = nil
    }
}

struct ExerciseDetailCard: View {
    let exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(exercise.name)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(exercise.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Label(exercise.category.rawValue, systemImage: "tag")
                Spacer()
                Label(exercise.equipment.rawValue, systemImage: "dumbbell")
            }
            .font(.caption)
            .foregroundColor(.secondary)
            
            // Instructions
            VStack(alignment: .leading, spacing: 8) {
                Text("Instructions:")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                ForEach(Array(exercise.instructions.enumerated()), id: \.offset) { index, instruction in
                    HStack(alignment: .top) {
                        Text("\(index + 1).")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(width: 20, alignment: .leading)
                        
                        Text(instruction)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    WorkoutView()
        .environmentObject(UserDataService())
        .environmentObject(ExerciseDataService())
} 