'use client';

import { useState, useEffect } from 'react';
import { User, Workout, UnitSystem } from '@/lib/types';
import { calculateLevel, recalculateWorkoutTotals } from '@/lib/gameLogic';
import { v4 as uuidv4 } from 'uuid';

const USER_STORAGE_KEY = 'metafit_user';
const WORKOUTS_STORAGE_KEY = 'metafit_workouts';

export const useUser = () => {
  const [user, setUser] = useState<User | null>(null);
  const [workouts, setWorkouts] = useState<Workout[]>([]);

  useEffect(() => {
    try {
      const userJson = localStorage.getItem(USER_STORAGE_KEY);
      const workoutsJson = localStorage.getItem(WORKOUTS_STORAGE_KEY);

      if (userJson) {
        setUser(JSON.parse(userJson));
      }
      if (workoutsJson) {
        setWorkouts(JSON.parse(workoutsJson));
      }
    } catch (error) {
      console.error('Failed to load data from localStorage', error);
      // If data is corrupted, clear it
      localStorage.removeItem(USER_STORAGE_KEY);
      localStorage.removeItem(WORKOUTS_STORAGE_KEY);
    }
  }, []);

  const saveData = (user: User, workouts: Workout[]) => {
    try {
      localStorage.setItem(USER_STORAGE_KEY, JSON.stringify(user));
      localStorage.setItem(WORKOUTS_STORAGE_KEY, JSON.stringify(workouts));
    } catch (error) {
      console.error('Failed to save data to localStorage', error);
    }
  };

  const createUser = (name: string, age: number, height: number, weight: number, unitSystem: UnitSystem) => {
    const newUser: User = {
      id: uuidv4(),
      name,
      age,
      height,
      weight,
      unitSystem,
      xpPoints: 0,
      level: 1,
      totalWorkouts: 0,
      totalCaloriesBurned: 0,
      dateCreated: new Date().toISOString(),
    };
    setUser(newUser);
    setWorkouts([]);
    saveData(newUser, []);
  };

  const updateUser = (updatedUser: User) => {
    const { level } = calculateLevel(updatedUser.xpPoints);
    const userWithLevel = { ...updatedUser, level };
    setUser(userWithLevel);
    saveData(userWithLevel, workouts);
  };

  const addWorkout = (newWorkout: Workout) => {
    if (!user) return;

    const processedWorkout = recalculateWorkoutTotals(newWorkout, user);
    
    const updatedWorkouts = [...workouts, processedWorkout];
    setWorkouts(updatedWorkouts);

    const updatedUser: User = {
      ...user,
      totalWorkouts: user.totalWorkouts + 1,
      totalCaloriesBurned: user.totalCaloriesBurned + processedWorkout.totalCaloriesBurned,
      xpPoints: user.xpPoints + processedWorkout.xpEarned,
      lastWorkoutDate: processedWorkout.date,
    };
    
    updateUser(updatedUser);
  };

  const clearData = () => {
    localStorage.removeItem(USER_STORAGE_KEY);
    localStorage.removeItem(WORKOUTS_STORAGE_KEY);
    setUser(null);
    setWorkouts([]);
  };

  return { user, workouts, createUser, updateUser, addWorkout, clearData };
}; 