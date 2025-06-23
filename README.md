# MetaFit - iOS Fitness Tracking Game

MetaFit is a gamified fitness tracking iOS app that combines workout tracking with an XP progression system. Users can input their age, height, and weight, then track exercises with sets, weights, and timing to earn XP points based on their effort and age.

## Features

### 🎮 Gamification
- **XP Progression System**: Earn XP based on calories burned, workout duration, and exercise variety
- **Age-Based Bonuses**: Older users receive bonus XP for the same effort (encouraging fitness at any age)
- **Level System**: Progress through levels with increasing XP requirements
- **Achievements**: Unlock achievements for milestones and consistent workouts
- **Streak Tracking**: Track consecutive workout days

### 💪 Workout Tracking
- **Exercise Library**: Comprehensive database of exercises 
- **Multiple Exercise Types**: Support for strength, cardio, flexibility, and more
- **Set & Rep Tracking**: Log sets, reps, weights, and rest times
- **Endurance Exercises**: Track duration-based exercises like running or cycling
- **Calorie Calculation**: Realistic calorie burn calculations based on exercise type, weight, and age

### 📊 Analytics & Progress
- **Dashboard**: Overview of current level, XP progress, and recent activity
- **Weekly/Monthly Stats**: Track workouts, calories burned, and XP earned
- **BMI Tracking**: Monitor BMI changes and categorization
- **Workout History**: Complete history of all workouts with detailed stats

### 👤 User Profile
- **Personal Information**: Age, height, weight, and BMI tracking
- **Progress Visualization**: Level progress bars and achievement tracking
- **Profile Management**: Edit personal information and view statistics

## Technical Architecture

### Models
- **User**: Profile information, XP, level, and statistics
- **Exercise**: Exercise definitions with calorie calculations and instructions
- **Workout**: Workout sessions with exercises and tracking data
- **WorkoutExercise**: Individual exercises within a workout
- **ExerciseSet**: Sets, reps, weights, and timing for strength exercises

### Services
- **UserDataService**: Manages user data persistence and XP calculations
- **ExerciseDataService**: Provides exercise database and filtering capabilities

### Views (SwiftUI)
- **ContentView**: Main app container with onboarding and navigation
- **DashboardView**: Overview of user progress and quick actions
- **WorkoutView**: Create and track workouts
- **ExerciseLibraryView**: Browse and search exercises
- **ProfileView**: User profile and statistics

## XP Calculation Algorithm

The XP system rewards users based on multiple factors:

1. **Base XP**: 10% of calories burned
2. **Age Bonus**: 2% bonus per year over 18 (encourages fitness at any age)
3. **Duration Bonus**: 2 XP per minute of workout time
4. **Exercise Variety**: 3 XP per unique muscle group targeted
5. **Difficulty Bonus**: 1-4 XP based on exercise difficulty level

### Example XP Calculation
For a 45-year-old user doing a 30-minute workout with 3 exercises targeting different muscle groups:
- Base calories: 300 → 30 XP
- Age bonus (45-18 = 27 years): 27 × 0.02 = 54% bonus → 46 XP
- Duration bonus: 30 minutes × 2 = 60 XP
- Variety bonus: 3 muscle groups × 3 = 9 XP
- Difficulty bonus: 6 XP (average)
- **Total: 121 XP**

## Getting Started

### Prerequisites
- Xcode 14.0 or later
- iOS 16.0 or later
- Swift 5.7 or later

### Installation
1. Clone the repository
2. Open `MetaFit.xcodeproj` in Xcode
3. Select your target device or simulator
4. Build and run the project

### First Time Setup
1. Enter your name, age, height, and weight
2. Browse the exercise library to familiarize yourself
3. Create your first workout
4. Start tracking your fitness journey!

## Data Persistence

The app uses `UserDefaults` for data persistence:
- User profile and progress
- Workout history
- Achievement status
- App preferences

## Exercise Database

The app includes a comprehensive exercise database with:
- **Exercise Categories**: Strength, Cardio, Flexibility, Balance, Calisthenics, Yoga, Pilates, Plyometrics, Stretching
- **Equipment Types**: No Equipment, Barbell, Dumbbells, Bench, Cable, Machine, Kettlebell, Resistance Band, Exercise Ball, Foam Roller, TRX Suspension, Full Gym
- **Muscle Groups**: Neck, Trapezius, Shoulders, Chest, Back, Erector Spinae, Biceps, Triceps, Forearm, Abs, Core, Legs, Calves, Hips, Full Body
- **Difficulty Levels**: Beginner, Intermediate, Advanced, Expert

## Design Principles

### Apple Human Interface Guidelines
- **Accessibility**: Support for Dynamic Type and VoiceOver
- **Responsive Design**: Adapts to different screen sizes and orientations
- **Intuitive Navigation**: Tab-based navigation with clear hierarchy
- **Visual Feedback**: Progress indicators, animations, and clear status updates

### Gamification Best Practices
- **Immediate Feedback**: XP earned immediately after workout completion
- **Progressive Difficulty**: Level system encourages continued engagement
- **Social Elements**: Achievement system provides recognition
- **Personalization**: Age-based bonuses make the experience relevant

## Future Enhancements

### Planned Features
- **HealthKit Integration**: Sync with Apple Health for comprehensive health tracking
- **Workout Plans**: Pre-built workout routines for different goals
- **Social Features**: Share achievements and compete with friends
- **Advanced Analytics**: Detailed progress charts and insights
- **Custom Exercises**: Allow users to add their own exercises
- **Workout Templates**: Save and reuse workout configurations

### Technical Improvements
- **Core Data**: Migrate from UserDefaults to Core Data for better data management
- **Cloud Sync**: iCloud integration for cross-device synchronization
- **Push Notifications**: Reminders and achievement notifications
- **Widgets**: iOS home screen widgets for quick stats
- **Apple Watch**: Companion app for workout tracking

## Contributing

This is a personal project, but suggestions and feedback are welcome! The app is designed to be educational and demonstrate iOS development best practices.

## License

This project is for educational purposes.

## Acknowledgments

- Apple Human Interface Guidelines for design principles
- SwiftUI framework for modern iOS development 
