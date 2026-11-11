import { useAuth } from "./hooks/useAuth";

function App() {
  const { user, logout, isLoading } = useAuth();

  if (isLoading) {
    return (
      <div className="flex h-screen items-center justify-center">
        <p className="text-gray-500">Loading...</p>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50 p-8">
      <header className="mx-auto flex max-w-4xl items-center justify-between border-b pb-4">
        <h1 className="text-2xl font-bold text-gray-800">Tutor Booking Platform</h1>
        <div>
          {user ? (
            <div className="flex items-center gap-4">
              <span className="text-sm text-gray-600">
                Logged in as: <strong>{user.firstName} ({user.role})</strong>
              </span>
              <button
                onClick={logout}
                className="rounded bg-red-500 px-3 py-1.5 text-sm text-white hover:bg-red-600"
              >
                Logout
              </button>
            </div>
          ) : (
            <span className="text-sm text-gray-500">Not logged in</span>
          )}
        </div>
      </header>

      <main className="mx-auto mt-8 max-w-4xl">
        <p className="text-gray-600">Welcome to the Tutor Booking application!</p>
      </main>
    </div>
  );
}

export default App;