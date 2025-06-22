import { UnitSystem } from '@/lib/types';

// MARK: - Weight Conversion

/**
 * Converts kilograms to pounds.
 * @param kg - The weight in kilograms.
 * @returns The weight in pounds.
 */
export const kgToLbs = (kg: number): number => {
  return kg * 2.20462;
};

/**
 * Converts pounds to kilograms.
 * @param lbs - The weight in pounds.
 * @returns The weight in kilograms.
 */
export const lbsToKg = (lbs: number): number => {
  return lbs / 2.20462;
};

// MARK: - Height Conversion

/**
 * Converts centimeters to inches.
 * @param cm - The height in centimeters.
 * @returns The height in inches.
 */
export const cmToInches = (cm: number): number => {
  return cm / 2.54;
};

/**
 * Converts inches to centimeters.
 * @param inches - The height in inches.
 * @returns The height in centimeters.
 */
export const inchesToCm = (inches: number): number => {
  return inches * 2.54;
};

/**
 * Converts centimeters to feet and inches.
 * @param cm - The height in centimeters.
 * @returns An object containing feet and inches.
 */
export const cmToFeetAndInches = (cm: number): { feet: number; inches: number } => {
  const totalInches = cmToInches(cm);
  const feet = Math.floor(totalInches / 12);
  const inches = totalInches % 12;
  return { feet, inches };
};

/**
 * Converts feet and inches to centimeters.
 * @param feet - The number of feet.
 * @param inches - The number of inches.
 * @returns The height in centimeters.
 */
export const feetAndInchesToCm = (feet: number, inches: number): number => {
  const totalInches = feet * 12 + inches;
  return inchesToCm(totalInches);
};

// MARK: - Display Strings

/**
 * Formats weight for display based on the selected unit system.
 * @param kg - The weight in kilograms.
 * @param system - The unit system to use for formatting.
 * @returns A formatted weight string.
 */
export const displayWeight = (kg: number, system: UnitSystem): string => {
  switch (system) {
    case UnitSystem.Metric:
      return `${kg.toFixed(1)} kg`;
    case UnitSystem.Imperial:
      const lbs = kgToLbs(kg);
      return `${lbs.toFixed(1)} lbs`;
  }
};

/**
 * Formats height for display based on the selected unit system.
 * @param cm - The height in centimeters.
 * @param system - The unit system to use for formatting.
 * @returns A formatted height string.
 */
export const displayHeight = (cm: number, system: UnitSystem): string => {
  switch (system) {
    case UnitSystem.Metric:
      return `${cm.toFixed(0)} cm`;
    case UnitSystem.Imperial:
      const { feet, inches } = cmToFeetAndInches(cm);
      return `${feet}' ${inches.toFixed(1)}"`;
  }
}; 