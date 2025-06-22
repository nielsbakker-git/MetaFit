'use client';

import { BarChartIcon, MedalIcon, UserCheckIcon } from 'lucide-react';

export function Features() {
  return (
    <section className="w-full py-12 md:py-24 lg:py-32 bg-muted">
      <div className="container px-4 md:px-6">
        <div className="flex flex-col items-center justify-center space-y-4 text-center">
          <div className="space-y-2">
            <div className="inline-block rounded-lg bg-muted-foreground/10 px-3 py-1 text-sm">Key Features</div>
            <h2 className="text-3xl font-bold tracking-tighter sm:text-5xl">Everything You Need to Succeed</h2>
            <p className="max-w-[900px] text-muted-foreground md:text-xl/relaxed lg:text-base/relaxed xl:text-xl/relaxed">
              MetaFit provides a comprehensive suite of tools to help you achieve your fitness goals.
            </p>
          </div>
        </div>
        <div className="mx-auto grid max-w-5xl items-center gap-6 py-12 lg:grid-cols-3 lg:gap-12">
          <div className="grid gap-1">
            <UserCheckIcon className="h-8 w-8 text-primary" />
            <h3 className="text-xl font-bold">Personalized Plans</h3>
            <p className="text-muted-foreground">
              Get workout and nutrition plans tailored to your specific goals and body type.
            </p>
          </div>
          <div className="grid gap-1">
            <BarChartIcon className="h-8 w-8 text-primary" />
            <h3 className="text-xl font-bold">Track Your Progress</h3>
            <p className="text-muted-foreground">
              Log your workouts, monitor your stats, and see your progress over time.
            </p>
          </div>
          <div className="grid gap-1">
            <MedalIcon className="h-8 w-8 text-primary" />
            <h3 className="text-xl font-bold">Gamified Experience</h3>
            <p className="text-muted-foreground">
              Earn XP, level up, and unlock achievements as you complete your workouts.
            </p>
          </div>
        </div>
      </div>
    </section>
  );
} 