'use client';

import Link from 'next/link';
import { Button } from '@/components/ui/button';

export function Cta() {
  return (
    <section className="w-full py-12 md:py-24 lg:py-32 bg-muted">
      <div className="container grid items-center justify-center gap-4 px-4 text-center md:px-6">
        <div className="space-y-3">
          <h2 className="text-3xl font-bold tracking-tighter md:text-4xl/tight">Ready to Get Started?</h2>
          <p className="mx-auto max-w-[600px] text-muted-foreground md:text-xl/relaxed lg:text-base/relaxed xl:text-xl/relaxed">
            Join MetaFit today and take the first step towards a healthier, more active lifestyle.
          </p>
        </div>
        <div className="mx-auto w-full max-w-sm space-y-2">
          <Button size="lg" className="w-full" asChild>
            <Link href="/dashboard">Sign Up for Free</Link>
          </Button>
        </div>
      </div>
    </section>
  );
} 