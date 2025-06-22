import { Exercise, ExerciseCategory, Equipment, Difficulty, MuscleGroup } from '@/lib/types';

export const exercises: Exercise[] = [
  // Strength Exercises
  {
    id: 'bench-press',
    name: 'Bench Press',
    category: ExerciseCategory.Strength,
    equipment: Equipment.Barbell,
    difficulty: Difficulty.Intermediate,
    primaryMuscles: [MuscleGroup.Chest, MuscleGroup.Triceps, MuscleGroup.Shoulders],
    description: 'A compound exercise that primarily targets the chest muscles using a barbell.',
    instructions: [
      'Lie on a flat bench with your feet planted firmly on the ground.',
      'Grip the barbell slightly wider than shoulder width.',
      'Lower the bar to your chest with control.',
      'Press the bar back up to the starting position.',
    ],
    baseCaloriesPerMinute: 8.0,
    weightMultiplier: 0.15,
    ageMultiplier: 1.0,
  },
  {
    id: 'squat',
    name: 'Squat',
    category: ExerciseCategory.Strength,
    equipment: Equipment.Barbell,
    difficulty: Difficulty.Intermediate,
    primaryMuscles: [MuscleGroup.Legs, MuscleGroup.Hips, MuscleGroup.Core],
    description: 'A fundamental lower body exercise that targets multiple muscle groups.',
    instructions: [
      'Place the barbell on your upper back.',
      'Stand with feet shoulder-width apart.',
      'Lower your body by bending at the knees and hips.',
      'Keep your chest up and back straight.',
      'Return to standing position.',
    ],
    baseCaloriesPerMinute: 10.0,
    weightMultiplier: 0.2,
    ageMultiplier: 1.0,
  },
  {
    id: 'deadlift',
    name: 'Deadlift',
    category: ExerciseCategory.Strength,
    equipment: Equipment.Barbell,
    difficulty: Difficulty.Advanced,
    primaryMuscles: [MuscleGroup.Back, MuscleGroup.ErectorSpinae, MuscleGroup.Legs, MuscleGroup.Hips],
    description: 'A compound exercise that targets the posterior chain.',
    instructions: [
      'Stand with feet hip-width apart.',
      'Bend at the hips and knees to grasp the bar.',
      'Keep your back straight and chest up.',
      'Lift the bar by extending your hips and knees.',
      'Return the bar to the ground with control.',
    ],
    baseCaloriesPerMinute: 12.0,
    weightMultiplier: 0.25,
    ageMultiplier: 1.0,
  },
  // ... (add all other exercises from the iOS app here)
]; 