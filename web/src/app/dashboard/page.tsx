import { UserButton } from '@clerk/nextjs';
import { auth } from '@clerk/nextjs/server';
import { exercises } from '@/lib/exercises';
import Link from 'next/link';
import { Card, CardHeader, CardTitle, CardDescription, CardContent } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';

export default async function DashboardPage() {
  const { userId } = await auth();

  return (
    <div className="container mx-auto p-6">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold">Dashboard</h1>
        <UserButton afterSignOutUrl="/" />
      </div>
      <p className="mb-4">Welcome to your MetaFit dashboard! Here is the exercise library.</p>
      
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {exercises.map((exercise) => (
          <Link href={`/dashboard/exercises/${exercise.id}`} key={exercise.id}>
            <Card className="hover:shadow-lg transition-shadow cursor-pointer h-full flex flex-col">
              <CardHeader>
                <CardTitle>{exercise.name}</CardTitle>
                <CardDescription>{exercise.category}</CardDescription>
              </CardHeader>
              <CardContent className="flex-grow">
                <p className="text-sm text-muted-foreground mb-4">{exercise.description}</p>
                <div className="flex flex-wrap gap-2">
                  {exercise.primaryMuscles.map((muscle) => (
                    <Badge key={muscle} variant="outline">{muscle}</Badge>
                  ))}
                </div>
              </CardContent>
            </Card>
          </Link>
        ))}
      </div>
    </div>
  );
}
