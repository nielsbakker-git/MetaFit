import SwiftUI

struct ExerciseLibraryView: View {
    @EnvironmentObject var exerciseDataService: ExerciseDataService
    @State private var searchText = ""
    @State private var selectedCategory: ExerciseCategory?
    @State private var selectedMuscleGroup: MuscleGroup?
    @State private var selectedEquipment: Equipment?
    @State private var showingFilters = false
    
    var filteredExercises: [Exercise] {
        var exercises = exerciseDataService.exercises
        
        if let category = selectedCategory {
            exercises = exercises.filter { $0.category == category }
        }
        
        if let muscleGroup = selectedMuscleGroup {
            exercises = exercises.filter { $0.primaryMuscles.contains(muscleGroup) }
        }
        
        if let equipment = selectedEquipment {
            exercises = exercises.filter { $0.equipment == equipment }
        }
        
        if !searchText.isEmpty {
            exercises = exercises.filter { exercise in
                exercise.name.lowercased().contains(searchText.lowercased()) ||
                exercise.description.lowercased().contains(searchText.lowercased()) ||
                exercise.primaryMuscles.contains { $0.rawValue.lowercased().contains(searchText.lowercased()) }
            }
        }
        
        return exercises
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("Search exercises...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                    
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Active Filters
                if hasActiveFilters {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            if let category = selectedCategory {
                                FilterTag(
                                    text: category.rawValue,
                                    onRemove: { selectedCategory = nil }
                                )
                            }
                            
                            if let muscleGroup = selectedMuscleGroup {
                                FilterTag(
                                    text: muscleGroup.rawValue,
                                    onRemove: { selectedMuscleGroup = nil }
                                )
                            }
                            
                            if let equipment = selectedEquipment {
                                FilterTag(
                                    text: equipment.rawValue,
                                    onRemove: { selectedEquipment = nil }
                                )
                            }
                            
                            Button("Clear All") {
                                selectedCategory = nil
                                selectedMuscleGroup = nil
                                selectedEquipment = nil
                            }
                            .font(.caption)
                            .foregroundColor(.blue)
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Exercise List
                List(filteredExercises) { exercise in
                    NavigationLink(destination: ExerciseDetailView(exercise: exercise)) {
                        ExerciseLibraryRowView(exercise: exercise)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Exercise Library")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingFilters = true }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .sheet(isPresented: $showingFilters) {
                FilterView(
                    selectedCategory: $selectedCategory,
                    selectedMuscleGroup: $selectedMuscleGroup,
                    selectedEquipment: $selectedEquipment
                )
            }
        }
    }
    
    private var hasActiveFilters: Bool {
        selectedCategory != nil || selectedMuscleGroup != nil || selectedEquipment != nil
    }
}

struct ExerciseLibraryRowView: View {
    let exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(exercise.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(exercise.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(exercise.category.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(categoryColor.opacity(0.2))
                        .foregroundColor(categoryColor)
                        .cornerRadius(8)
                    
                    Text(exercise.difficulty.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Muscle groups
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(exercise.primaryMuscles, id: \.self) { muscle in
                        Text(muscle.rawValue)
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(4)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    private var categoryColor: Color {
        switch exercise.category {
        case .strength:
            return .blue
        case .cardio:
            return .red
        case .flexibility:
            return .green
        case .balance:
            return .purple
        case .calisthenics:
            return .orange
        case .yoga:
            return .pink
        case .pilates:
            return .mint
        case .plyometrics:
            return .indigo
        case .stretching:
            return .teal
        }
    }
}

struct FilterTag: View {
    let text: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.blue.opacity(0.1))
        .foregroundColor(.blue)
        .cornerRadius(12)
    }
}

struct FilterView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedCategory: ExerciseCategory?
    @Binding var selectedMuscleGroup: MuscleGroup?
    @Binding var selectedEquipment: Equipment?
    
    var body: some View {
        NavigationView {
            List {
                // Category Filter
                Section("Category") {
                    ForEach(ExerciseCategory.allCases, id: \.self) { category in
                        FilterRowView(
                            title: category.rawValue,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = selectedCategory == category ? nil : category
                        }
                    }
                }
                
                // Muscle Group Filter
                Section("Muscle Group") {
                    ForEach(MuscleGroup.allCases, id: \.self) { muscle in
                        FilterRowView(
                            title: muscle.rawValue,
                            isSelected: selectedMuscleGroup == muscle
                        ) {
                            selectedMuscleGroup = selectedMuscleGroup == muscle ? nil : muscle
                        }
                    }
                }
                
                // Equipment Filter
                Section("Equipment") {
                    ForEach(Equipment.allCases, id: \.self) { equipment in
                        FilterRowView(
                            title: equipment.rawValue,
                            isSelected: selectedEquipment == equipment
                        ) {
                            selectedEquipment = selectedEquipment == equipment ? nil : equipment
                        }
                    }
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        selectedCategory = nil
                        selectedMuscleGroup = nil
                        selectedEquipment = nil
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct FilterRowView: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ExerciseDetailView: View {
    let exercise: Exercise
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    Text(exercise.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(exercise.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Stats
                HStack(spacing: 20) {
                    StatBadge(
                        title: "Category",
                        value: exercise.category.rawValue,
                        icon: "tag"
                    )
                    
                    StatBadge(
                        title: "Difficulty",
                        value: exercise.difficulty.rawValue,
                        icon: "star"
                    )
                    
                    StatBadge(
                        title: "Equipment",
                        value: exercise.equipment.rawValue,
                        icon: "dumbbell"
                    )
                }
                
                // Muscle Groups
                VStack(alignment: .leading, spacing: 10) {
                    Text("Target Muscles")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 8) {
                        ForEach(exercise.primaryMuscles, id: \.self) { muscle in
                            Text(muscle.rawValue)
                                .font(.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(8)
                        }
                    }
                }
                
                // Instructions
                VStack(alignment: .leading, spacing: 10) {
                    Text("Instructions")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    ForEach(Array(exercise.instructions.enumerated()), id: \.offset) { index, instruction in
                        HStack(alignment: .top, spacing: 12) {
                            Text("\(index + 1)")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                                .frame(width: 24, height: 24)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(12)
                            
                            Text(instruction)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                    }
                }
                
                // Calorie Info
                VStack(alignment: .leading, spacing: 10) {
                    Text("Calorie Information")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Base calories per minute:")
                            Spacer()
                            Text("\(Int(exercise.baseCaloriesPerMinute))")
                                .fontWeight(.semibold)
                        }
                        
                        if exercise.weightMultiplier > 0 {
                            HStack {
                                Text("Weight multiplier:")
                                Spacer()
                                Text("\(exercise.weightMultiplier, specifier: "%.2f")")
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle("Exercise Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StatBadge: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
            
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
            
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

#Preview {
    ExerciseLibraryView()
        .environmentObject(ExerciseDataService())
} 