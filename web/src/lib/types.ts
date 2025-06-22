export enum UnitSystem {
  Metric = 'Metric',
  Imperial = 'Imperial',
}

export interface User {
  id: string;
  name: string;
  age: number;
  height: number; // stored in cm
  weight: number; // stored in kg
  unitSystem: UnitSystem;
  xpPoints: number;
  level: number;
  totalWorkouts: number;
  totalCaloriesBurned: number;
  dateCreated: string;
  lastWorkoutDate?: string;
}

export interface Workout {
  id: string;
  date: string;
  name: string;
  exercises: WorkoutExercise[];
  totalDuration: number; // in seconds
  totalCaloriesBurned: number;
  xpEarned: number;
  notes?: string;
}

export interface WorkoutExercise {
  id: string;
  exercise: Exercise;
  sets: ExerciseSet[];
  duration?: number; // for endurance exercises, in seconds
  notes?: string;
}

export interface ExerciseSet {
  id: string;
  reps?: number;
  weight: number; // in kg
  duration: number; // in seconds
  distance?: number; // in meters
  restTime: number; // in seconds
}

export interface Exercise {
  id: string;
  name: string;
  category: ExerciseCategory;
  equipment: Equipment;
  difficulty: Difficulty;
  primaryMuscles: MuscleGroup[];
  description: string;
  instructions: string[];
  imageURL?: string;
  baseCaloriesPerMinute: number;
  weightMultiplier: number;
  ageMultiplier: number;
}

export enum ExerciseCategory {
  Strength = 'Strength',
  Cardio = 'Cardio',
  Flexibility = 'Flexibility',
  Balance = 'Balance',
  Calisthenics = 'Calisthenics',
  Yoga = 'Yoga',
  Pilates = 'Pilates',
  Plyometrics = 'Plyometrics',
  Stretching = 'Stretching',
}

export enum Equipment {
  NoEquipment = 'No Equipment',
  Barbell = 'Barbell',
  Dumbbells = 'Dumbbells',
  Bench = 'Bench',
  Cable = 'Cable',
  Machine = 'Machine',
  Kettlebell = 'Kettlebell',
  ResistanceBand = 'Resistance Band',
  ExerciseBall = 'Exercise Ball',
  FoamRoller = 'Foam Roller',
  TRX = 'TRX Suspension',
  FullGym = 'Full Gym',
}

export enum Difficulty {
  Beginner = 'Beginner',
  Intermediate = 'Intermediate',
  Advanced = 'Advanced',
  Expert = 'Expert',
}

export enum MuscleGroup {
  Neck = 'Neck',
  Trapezius = 'Trapezius',
  Shoulders = 'Shoulders',
  Chest = 'Chest',
  Back = 'Back',
  ErectorSpinae = 'Erector Spinae',
  Biceps = 'Biceps',
  Triceps = 'Triceps',
  Forearm = 'Forearm',
  Abs = 'Abs',
  Core = 'Core',
  Legs = 'Legs',
  Calves = 'Calves',
  Hips = 'Hips',
  FullBody = 'Full Body',
} 