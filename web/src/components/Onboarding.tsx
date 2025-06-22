'use client';

import { useState } from 'react';
import { UnitSystem } from '@/lib/types';
import { lbsToKg, feetAndInchesToCm } from '@/lib/unitConverter';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';

interface OnboardingProps {
  onOnboard: (
    name: string,
    age: number,
    height: number,
    weight: number,
    unitSystem: UnitSystem
  ) => void;
}

export function Onboarding({ onOnboard }: OnboardingProps) {
  const [name, setName] = useState('');
  const [age, setAge] = useState('');
  const [height, setHeight] = useState('');
  const [heightInches, setHeightInches] = useState('');
  const [weight, setWeight] = useState('');
  const [unitSystem, setUnitSystem] = useState<UnitSystem>(UnitSystem.Metric);
  const [error, setError] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setError('');

    const ageNum = parseInt(age);
    const heightNum = parseFloat(height);
    const weightNum = parseFloat(weight);

    if (!name || !age || !height || !weight) {
      setError('All fields are required.');
      return;
    }

    if (isNaN(ageNum) || ageNum <= 0) {
      setError('Please enter a valid age.');
      return;
    }

    let heightInCm: number;
    let weightInKg: number;

    if (unitSystem === UnitSystem.Metric) {
      if (isNaN(heightNum) || isNaN(weightNum) || heightNum <= 0 || weightNum <= 0) {
        setError('Please enter valid height and weight.');
        return;
      }
      heightInCm = heightNum;
      weightInKg = weightNum;
    } else {
      const heightInchesNum = parseFloat(heightInches);
      if (
        isNaN(heightNum) ||
        isNaN(heightInchesNum) ||
        isNaN(weightNum) ||
        heightNum < 0 ||
        heightInchesNum < 0 ||
        weightNum <= 0
      ) {
        setError('Please enter valid height and weight.');
        return;
      }
      heightInCm = feetAndInchesToCm(heightNum, heightInchesNum);
      weightInKg = lbsToKg(weightNum);
    }

    onOnboard(name, ageNum, heightInCm, weightInKg, unitSystem);
  };

  return (
    <div className="flex items-center justify-center min-h-screen bg-background">
      <Card className="w-full max-w-md mx-4">
        <CardHeader>
          <CardTitle className="text-2xl font-bold text-center">
            Welcome to MetaFit
          </CardTitle>
          <CardDescription className="text-center">
            Let's set up your profile to get started.
          </CardDescription>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="unit-system">Unit System</Label>
              <Select
                value={unitSystem}
                onValueChange={(value: string) => setUnitSystem(value as UnitSystem)}
              >
                <SelectTrigger>
                  <SelectValue placeholder="Select unit system" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value={UnitSystem.Metric}>Metric</SelectItem>
                  <SelectItem value={UnitSystem.Imperial}>Imperial</SelectItem>
                </SelectContent>
              </Select>
            </div>

            <div className="space-y-2">
              <Label htmlFor="name">Name</Label>
              <Input
                id="name"
                value={name}
                onChange={(e: React.ChangeEvent<HTMLInputElement>) => setName(e.target.value)}
                placeholder="E.g. John Doe"
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="age">Age</Label>
              <Input
                id="age"
                type="number"
                value={age}
                onChange={(e: React.ChangeEvent<HTMLInputElement>) => setAge(e.target.value)}
                placeholder="E.g. 30"
              />
            </div>

            {unitSystem === UnitSystem.Metric ? (
              <div className="space-y-2">
                <Label htmlFor="height-cm">Height (cm)</Label>
                <Input
                  id="height-cm"
                  type="number"
                  value={height}
                  onChange={(e: React.ChangeEvent<HTMLInputElement>) => setHeight(e.target.value)}
                  placeholder="E.g. 180"
                />
              </div>
            ) : (
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="height-ft">Height (ft)</Label>
                  <Input
                    id="height-ft"
                    type="number"
                    value={height}
                    onChange={(e: React.ChangeEvent<HTMLInputElement>) => setHeight(e.target.value)}
                    placeholder="E.g. 5"
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="height-in">Height (in)</Label>
                  <Input
                    id="height-in"
                    type="number"
                    value={heightInches}
                    onChange={(e: React.ChangeEvent<HTMLInputElement>) => setHeightInches(e.target.value)}
                    placeholder="E.g. 11"
                  />
                </div>
              </div>
            )}

            <div className="space-y-2">
              <Label htmlFor="weight">
                Weight ({unitSystem === UnitSystem.Metric ? 'kg' : 'lbs'})
              </Label>
              <Input
                id="weight"
                type="number"
                value={weight}
                onChange={(e: React.ChangeEvent<HTMLInputElement>) => setWeight(e.target.value)}
                placeholder={
                  unitSystem === UnitSystem.Metric ? 'E.g. 75' : 'E.g. 165'
                }
              />
            </div>

            {error && <p className="text-sm text-destructive">{error}</p>}

            <Button type="submit" className="w-full">
              Create Profile
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  );
} 