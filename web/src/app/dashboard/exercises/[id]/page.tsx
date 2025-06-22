import { exercises } from '@/lib/exercises';
import { Card, CardHeader, CardTitle, CardDescription, CardContent } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import Link from 'next/link';
import { Button } from '@/components/ui/button';
import { ArrowLeft } from 'lucide-react';

export default function ExerciseDetailPage({ params }: { params: { id: string } }) {
  const exercise = exercises.find((e) => e.id === params.id);

  if (!exercise) {
    return (
      <div className="container mx-auto p-6">
        <h1 className="text-2xl font-bold">Exercise not found</h1>
        <Link href="/dashboard">
          <Button variant="link">
            <ArrowLeft className="mr-2 h-4 w-4" />
            Back to Dashboard
          </Button>
        </Link>
      </div>
    );
  }

  return (
    <div className="container mx-auto p-6">
      <Link href="/dashboard" className="mb-6 inline-block">
        <Button variant="outline">
          <ArrowLeft className="mr-2 h-4 w-4" />
          Back to Library
        </Button>
      </Link>
      <Card>
        <CardHeader>
          <div className="flex justify-between items-start">
            <div>
              <CardTitle className="text-3xl font-bold">{exercise.name}</CardTitle>
              <CardDescription className="text-lg">{exercise.category}</CardDescription>
            </div>
            <Badge variant="secondary">{exercise.difficulty}</Badge>
          </div>
        </CardHeader>
        <CardContent>
          <div className="grid md:grid-cols-2 gap-8">
            <div>
              <h3 className="font-semibold text-xl mb-2">Description</h3>
              <p className="text-muted-foreground mb-6">{exercise.description}</p>

              <h3 className="font-semibold text-xl mb-2">Instructions</h3>
              <ol className="list-decimal list-inside space-y-2 text-muted-foreground">
                {exercise.instructions.length > 0 ? (
                  exercise.instructions.map((step, index) => <li key={index}>{step}</li>)
                ) : (
                  <li>No instructions provided yet.</li>
                )}
              </ol>
            </div>
            <div>
              <div className="bg-muted rounded-lg h-64 w-full flex items-center justify-center mb-6">
                <p className="text-muted-foreground">Visual Example (GIF/Image) coming soon!</p>
              </div>

              <h3 className="font-semibold text-xl mb-2">Primary Muscles</h3>
              <div className="flex flex-wrap gap-2 mb-4">
                {exercise.primaryMuscles.map((muscle) => (
                  <Badge key={muscle}>{muscle}</Badge>
                ))}
              </div>

              <h3 className="font-semibold text-xl mb-2">Equipment</h3>
              <Badge variant="outline">{exercise.equipment}</Badge>

            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  );
} 