'use client';

import { App } from '@/components/App';
import { Onboarding } from '@/components/Onboarding';
import { useUser } from '@/hooks/useUser';

export default function Home() {
  const { user, createUser, updateUser, addWorkout, clearData } = useUser();

  if (!user) {
    return <Onboarding onOnboard={createUser} />;
  }

  return <App user={user} onUpdateUser={updateUser} onAddWorkout={addWorkout} onClearData={clearData} />;
}
