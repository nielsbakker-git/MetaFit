'use client';

import { User } from '@/lib/types';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';

interface AppProps {
  user: User;
  onClearData: () => void;
}

export function App({ user, onClearData }: AppProps) {
  return (
    <div className="container mx-auto p-6 max-w-4xl">
      <div className="space-y-6">
        {/* Header */}
        <div className="text-center">
          <h1 className="text-4xl font-bold text-primary">MetaFit</h1>
          <p className="text-muted-foreground mt-2">Your gamified fitness journey</p>
        </div>

        {/* User Stats */}
        <Card>
          <CardHeader>
            <CardTitle>Welcome back, {user.name}!</CardTitle>
            <CardDescription>Your fitness stats and progress</CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div className="text-center">
                <div className="text-2xl font-bold text-primary">{user.level}</div>
                <div className="text-sm text-muted-foreground">Level</div>
              </div>
              <div className="text-center">
                <div className="text-2xl font-bold text-primary">{user.xpPoints}</div>
                <div className="text-sm text-muted-foreground">XP</div>
              </div>
              <div className="text-center">
                <div className="text-2xl font-bold text-primary">{user.totalWorkouts}</div>
                <div className="text-sm text-muted-foreground">Workouts</div>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Quick Actions */}
        <Card>
          <CardHeader>
            <CardTitle>Quick Actions</CardTitle>
            <CardDescription>Start your fitness journey</CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <Button className="w-full" size="lg">
                Start Workout
              </Button>
              <Button className="w-full" size="lg" variant="outline">
                View Exercise Library
              </Button>
            </div>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <Button className="w-full" variant="outline">
                Edit Profile
              </Button>
              <Button 
                className="w-full" 
                variant="destructive"
                onClick={onClearData}
              >
                Clear Data
              </Button>
            </div>
          </CardContent>
        </Card>

        {/* User Info */}
        <Card>
          <CardHeader>
            <CardTitle>Profile Information</CardTitle>
            <CardDescription>Your personal fitness data</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <div className="text-sm font-medium text-muted-foreground">Age</div>
                <div className="text-lg">{user.age} years</div>
              </div>
              <div>
                <div className="text-sm font-medium text-muted-foreground">Height</div>
                <div className="text-lg">{user.height} cm</div>
              </div>
              <div>
                <div className="text-sm font-medium text-muted-foreground">Weight</div>
                <div className="text-lg">{user.weight} kg</div>
              </div>
              <div>
                <div className="text-sm font-medium text-muted-foreground">Units</div>
                <div className="text-lg">{user.unitSystem}</div>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
} 