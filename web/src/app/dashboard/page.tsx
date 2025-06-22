import { UserButton } from '@clerk/nextjs';
import { auth } from '@clerk/nextjs/server';

export default async function DashboardPage() {
  const { userId } = await auth();

  return (
    <div className="container mx-auto p-6">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold">Dashboard</h1>
        <UserButton afterSignOutUrl="/" />
      </div>
      <p>Welcome to your MetaFit dashboard!</p>
      <p>Your User ID is: {userId}</p>
    </div>
  );
}
