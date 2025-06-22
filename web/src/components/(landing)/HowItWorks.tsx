'use client';

export function HowItWorks() {
  return (
    <section className="w-full py-12 md:py-24 lg:py-32 bg-background">
      <div className="container grid items-center justify-center gap-4 px-4 text-center md:px-6">
        <div className="space-y-3">
          <h2 className="text-3xl font-bold tracking-tighter md:text-4xl/tight">How It Works</h2>
          <p className="mx-auto max-w-[600px] text-muted-foreground md:text-xl/relaxed lg:text-base/relaxed xl:text-xl/relaxed">
            Getting started with MetaFit is easy. Just follow these simple steps.
          </p>
        </div>
        <div className="relative mx-auto max-w-5xl grid gap-8 lg:grid-cols-3">
          <div className="flex flex-col items-center gap-4 p-4 rounded-lg">
            <div className="flex h-12 w-12 items-center justify-center rounded-full bg-primary text-primary-foreground font-bold text-xl">
              1
            </div>
            <div className="text-center">
              <h3 className="text-xl font-bold">Sign Up</h3>
              <p className="text-muted-foreground">
                Create your account and set up your profile in minutes.
              </p>
            </div>
          </div>
          <div className="flex flex-col items-center gap-4 p-4 rounded-lg">
            <div className="flex h-12 w-12 items-center justify-center rounded-full bg-primary text-primary-foreground font-bold text-xl">
              2
            </div>
            <div className="text-center">
              <h3 className="text-xl font-bold">Set Your Goals</h3>
              <p className="text-muted-foreground">
                Tell us what you want to achieve and we&apos;ll create a plan for you.
              </p>
            </div>
          </div>
          <div className="flex flex-col items-center gap-4 p-4 rounded-lg">
            <div className="flex h-12 w-12 items-center justify-center rounded-full bg-primary text-primary-foreground font-bold text-xl">
              3
            </div>
            <div className="text-center">
              <h3 className="text-xl font-bold">Start Training</h3>
              <p className="text-muted-foreground">
                Follow your plan, track your progress, and start seeing results.
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
} 