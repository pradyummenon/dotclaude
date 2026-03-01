# skill: react patterns

## component patterns

### container/presenter separation
```tsx
// presenter — pure UI, receives props
function PatientCard({ patient, onEdit }: PatientCardProps) {
  return (
    <div className="card">
      <h3>{patient.name}</h3>
      <p>{patient.condition}</p>
      <button onClick={() => onEdit(patient.id)}>Edit</button>
    </div>
  );
}

// container — handles data and state
function PatientCardContainer({ patientId }: { patientId: string }) {
  const { data: patient, isLoading } = usePatient(patientId);
  const { mutate: editPatient } = useEditPatient();

  if (isLoading) return <PatientCardSkeleton />;
  if (!patient) return null;

  return <PatientCard patient={patient} onEdit={editPatient} />;
}
```

### custom hooks for reusable logic
```tsx
function useDebounce<T>(value: T, delay: number): T {
  const [debouncedValue, setDebouncedValue] = useState(value);

  useEffect(() => {
    const timer = setTimeout(() => setDebouncedValue(value), delay);
    return () => clearTimeout(timer);
  }, [value, delay]);

  return debouncedValue;
}
```

## state management

### server state — React Query / TanStack Query
```tsx
function usePatients(filters: PatientFilters) {
  return useQuery({
    queryKey: ["patients", filters],
    queryFn: () => patientApi.list(filters),
    staleTime: 5 * 60 * 1000,
  });
}
```

### client state — Zustand (for global UI state)
```tsx
const useUIStore = create<UIState>((set) => ({
  sidebarOpen: true,
  toggleSidebar: () => set((s) => ({ sidebarOpen: !s.sidebarOpen })),
}));
```

### local state — useState for component-scoped state
- form inputs, toggles, modal open/close

## error boundaries
```tsx
function ErrorBoundary({ children, fallback }: ErrorBoundaryProps) {
  return (
    <ReactErrorBoundary
      FallbackComponent={fallback ?? DefaultErrorFallback}
      onError={(error) => logger.error("React error boundary caught", { error })}
    >
      {children}
    </ReactErrorBoundary>
  );
}
```

## performance patterns
- `React.memo` for expensive pure components
- `useMemo` for expensive computations
- `useCallback` for stable function references passed as props
- lazy load routes: `const Dashboard = lazy(() => import("./Dashboard"))`

## anti-patterns to avoid
- prop drilling more than 2 levels — use context or composition
- `useEffect` for derived state — compute during render instead
- `any` types in props — always define proper interfaces
- inline object/array creation in JSX — causes unnecessary re-renders
