'use client';

import { Navbar } from './(landing)/Navbar';
import { Hero } from './(landing)/Hero';
import { Features } from './(landing)/Features';
import { HowItWorks } from './(landing)/HowItWorks';
import { Cta } from './(landing)/Cta';
import { Footer } from './(landing)/Footer';

export function LandingPage() {
  return (
    <div className="flex flex-col min-h-screen">
      <Navbar />
      <main className="flex-grow">
        <Hero />
        <Features />
        <HowItWorks />
        <Cta />
      </main>
      <Footer />
    </div>
  );
} 