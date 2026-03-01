# skill: next.js patterns (app router)

## server vs client components

### default to server components
```tsx
// app/patients/page.tsx — server component by default
async function PatientsPage() {
  const patients = await patientService.list(); // direct server call
  return <PatientList patients={patients} />;
}
```

### client components only when needed
```tsx
"use client";

// use client for: event handlers, hooks, browser APIs, interactive UI
function PatientSearch() {
  const [query, setQuery] = useState("");
  const debouncedQuery = useDebounce(query, 300);
  // ...
}
```

## data fetching patterns

### server component fetching (preferred)
```tsx
// fetch in the component that needs the data
async function PatientDetail({ params }: { params: { id: string } }) {
  const patient = await getPatient(params.id);
  if (!patient) notFound();
  return <PatientProfile patient={patient} />;
}
```

### route handlers (API routes)
```tsx
// app/api/patients/route.ts
export async function GET(request: NextRequest) {
  const searchParams = request.nextUrl.searchParams;
  const patients = await patientService.list({
    page: Number(searchParams.get("page") ?? 1),
  });
  return NextResponse.json(patients);
}

export async function POST(request: NextRequest) {
  const body = await request.json();
  const validated = createPatientSchema.parse(body);
  const patient = await patientService.create(validated);
  return NextResponse.json(patient, { status: 201 });
}
```

## middleware
```tsx
// middleware.ts — runs on edge for every request
export function middleware(request: NextRequest) {
  const token = request.cookies.get("session");
  if (!token && request.nextUrl.pathname.startsWith("/dashboard")) {
    return NextResponse.redirect(new URL("/login", request.url));
  }
}

export const config = {
  matcher: ["/dashboard/:path*", "/api/:path*"],
};
```

## loading and error states
```tsx
// app/patients/loading.tsx — automatic loading UI
export default function Loading() {
  return <PatientListSkeleton />;
}

// app/patients/error.tsx — automatic error UI
"use client";
export default function Error({ error, reset }: { error: Error; reset: () => void }) {
  return (
    <div>
      <h2>Something went wrong</h2>
      <button onClick={reset}>Try again</button>
    </div>
  );
}
```

## key decisions
- **SSR vs SSG vs ISR**: SSR for personalized data, SSG for public pages, ISR for semi-dynamic
- **Server Actions** for mutations from server components
- **Parallel routes** for complex layouts with independent loading states
- **Intercepting routes** for modals that work as standalone pages too

## common pitfalls
- `useSearchParams()` causes full page de-opt from SSR — wrap in Suspense
- server components can't use hooks or event handlers
- don't pass functions from server to client components (not serializable)
- `fetch` in server components is auto-deduped — don't worry about multiple calls
