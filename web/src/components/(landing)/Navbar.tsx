'use client';

import Link from 'next/link';
import { Button } from '@/components/ui/button';
import { MountainIcon } from 'lucide-react';

export function Navbar() {
  return (
    <header className="px-4 lg:px-6 h-14 flex items-center bg-background">
      <Link href="/" className="flex items-center justify-center" prefetch={false}>
        <MountainIcon className="h-6 w-6" />
        <span className="sr-only">MetaFit</span>
      </Link>
      <nav className="ml-auto flex gap-4 sm:gap-6">
        <Button asChild>
          <Link href="/dashboard">Get Started</Link>
        </Button>
      </nav>
    </header>
  );
} 