import {
  Difficulty,
  Exercise,
  Workout,
  User,
  WorkoutExercise,
} from '@/lib/types';

// MARK: - XP Calculation

/**
 * Calculates the XP for a given workout and user age.
 * @param workout - The workout object.
 * @param userAge - The age of the user.
 * @returns The total XP earned for the workout.
 */
export const calculateXPForWorkout = (workout: Workout, userAge: number): number => {
  let xp = Math.floor(workout.totalCaloriesBurned * 0.1); // Base XP from calories

  // Age bonus: older users get more XP
  const ageBonus = Math.max(1.0, (userAge - 18) * 0.02);
  xp = Math.floor(xp * ageBonus);

  // Duration bonus
  xp += Math.floor(workout.totalDuration / 60) * 2; // 2 XP per minute

  // Exercise variety bonus
  const muscleGroups = new Set(
    workout.exercises.flatMap((e) => e.exercise.primaryMuscles)
  );
  xp += muscleGroups.size * 3;

  // Difficulty bonus
  const difficultyBonus = workout.exercises.reduce(
    (total, e) => total + getDifficultyMultiplier(e.exercise.difficulty),
    0
  );
  xp += difficultyBonus;

  return Math.max(1, xp); // Minimum 1 XP
};

const getDifficultyMultiplier = (difficulty: Difficulty): number => {
  switch (difficulty) {
    case Difficulty.Beginner:
      return 1;
    case Difficulty.Intermediate:
      return 2;
    case Difficulty.Advanced:
      return 3;
    case Difficulty.Expert:
      return 4;
    default:
      return 1;
  }
};

// MARK: - Calorie Calculation

/**
 * Calculates the calories burned for a single exercise.
 * @param exercise - The exercise object.
 * @param duration - The duration of the exercise in seconds.
 * @param userWeight - The user's weight in kg.
 * @param userAge - The user's age.
 * @param exerciseWeight - The weight used for the exercise in kg.
 * @returns The total calories burned.
 */
export const calculateCaloriesBurnedForExercise = (
  exercise: Exercise,
  duration: number,
  userWeight: number,
  userAge: number,
  exerciseWeight = 0
): number => {
  const minutes = duration / 60;
  let calories = exercise.baseCaloriesPerMinute * minutes;

  if (exerciseWeight > 0) {
    calories += exerciseWeight * exercise.weightMultiplier * minutes;
  }

  calories += userWeight * 0.1 * minutes;

  const ageFactor = Math.max(0.7, 1.0 - (userAge - 25) * 0.005);
  calories *= ageFactor;

  return calories;
};

// MARK: - Workout Totals

/**
 * Recalculates the total duration and calories for a workout.
 * @param workout - The workout to update.
 * @param user - The current user.
 * @returns The updated workout object.
 */
export const recalculateWorkoutTotals = (
  workout: Workout,
  user: User
): Workout => {
  const updatedExercises = workout.exercises.map((we) =>
    recalculateWorkoutExerciseTotals(we, user)
  );

  const totalDuration = updatedExercises.reduce(
    (total, we) => total + (we.totalDuration || 0),
    0
  );
  const totalCaloriesBurned = updatedExercises.reduce(
    (total, we) => total + (we.totalCaloriesBurned || 0),
    0
  );

  const updatedWorkout = {
    ...workout,
    exercises: updatedExercises,
    totalDuration,
    totalCaloriesBurned,
  };

  const xpEarned = calculateXPForWorkout(updatedWorkout, user.age);

  return { ...updatedWorkout, xpEarned };
};

interface WorkoutExerciseWithTotals extends WorkoutExercise {
  totalDuration: number;
  totalCaloriesBurned: number;
}

const recalculateWorkoutExerciseTotals = (
  workoutExercise: WorkoutExercise,
  user: User
): WorkoutExerciseWithTotals => {
  let totalDuration: number;
  let totalCaloriesBurned: number;

  if (workoutExercise.duration) {
    // Endurance exercise
    totalDuration = workoutExercise.duration;
    totalCaloriesBurned = calculateCaloriesBurnedForExercise(
      workoutExercise.exercise,
      totalDuration,
      user.weight,
      user.age
    );
  } else {
    // Strength exercise
    const exerciseTime = workoutExercise.sets.reduce(
      (acc, set) => acc + set.duration,
      0
    );
    const restTime = Math.max(0, workoutExercise.sets.length - 1) * 60;
    totalDuration = exerciseTime + restTime;

    totalCaloriesBurned = workoutExercise.sets.reduce((total, set) => {
      return (
        total +
        calculateCaloriesBurnedForExercise(
          workoutExercise.exercise,
          set.duration,
          user.weight,
          user.age,
          set.weight
        )
      );
    }, 0);
  }

  return { ...workoutExercise, totalDuration, totalCaloriesBurned };
};

// MARK: - User Stats

/**
 * Calculates user level based on XP.
 * @param xpPoints - The total XP points.
 * @returns The user's current level.
 */
export const calculateLevel = (xpPoints: number): { level: number; progress: number; xpToNextLevel: number } => {
  let level = 1;
  let xpForNextLevel = 100;
  let xpForCurrentLevel = 0;

  while (xpPoints >= xpForNextLevel) {
    xpForCurrentLevel = xpForNextLevel;
    level++;
    xpForNextLevel += level * 100;
  }

  const xpInCurrentLevel = xpPoints - xpForCurrentLevel;
  const totalXpForThisLevel = xpForNextLevel - xpForCurrentLevel;
  const progress = totalXpForThisLevel > 0 ? xpInCurrentLevel / totalXpForThisLevel : 0;
  const xpToNextLevel = totalXpForThisLevel;

  return { level, progress, xpToNextLevel };
}; 