# skill: typescript strict patterns

## strict mode config
```json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "exactOptionalPropertyTypes": true
  }
}
```

## discriminated unions (over type assertions)

```typescript
type ApiResult<T> =
  | { status: "success"; data: T }
  | { status: "error"; error: string; code: number }
  | { status: "loading" };

function handleResult(result: ApiResult<Patient>) {
  switch (result.status) {
    case "success":
      return renderPatient(result.data); // TS knows data exists
    case "error":
      return renderError(result.error);  // TS knows error exists
    case "loading":
      return renderSkeleton();
  }
}
```

## branded types (for type-safe IDs)

```typescript
type PatientId = string & { readonly __brand: "PatientId" };
type DoctorId = string & { readonly __brand: "DoctorId" };

function createPatientId(id: string): PatientId {
  return id as PatientId;
}

// now this is a compile error:
// assignDoctor(patientId: DoctorId) — can't pass PatientId
```

## zod for runtime validation

```typescript
import { z } from "zod";

const PatientSchema = z.object({
  name: z.string().min(1).max(200),
  age: z.number().int().positive().max(150),
  conditions: z.array(z.string()).default([]),
});

type Patient = z.infer<typeof PatientSchema>;

// validate at system boundaries
const parsed = PatientSchema.safeParse(requestBody);
if (!parsed.success) {
  return { error: parsed.error.flatten() };
}
```

## utility types

```typescript
// make specific fields required
type PatientWithId = Patient & { id: PatientId };

// pick subset of fields
type PatientSummary = Pick<Patient, "id" | "name">;

// omit fields for creation DTOs
type CreatePatientInput = Omit<Patient, "id" | "createdAt">;

// make all fields optional for updates
type UpdatePatientInput = Partial<Omit<Patient, "id">>;

// Record for typed maps
type PatientIndex = Record<PatientId, Patient>;
```

## generics patterns

```typescript
// generic repository interface
interface Repository<T, ID> {
  findById(id: ID): Promise<T | null>;
  findAll(filter?: Partial<T>): Promise<T[]>;
  save(entity: T): Promise<T>;
  delete(id: ID): Promise<void>;
}

// generic result wrapper
type Result<T, E = Error> =
  | { ok: true; value: T }
  | { ok: false; error: E };
```

## anti-patterns to avoid
- `any` — use `unknown` and narrow with type guards
- `as` type assertions — use discriminated unions or type guards
- `!` non-null assertion — handle the null case explicitly
- `enum` — use `as const` objects or union types instead
- `interface` for everything — use `type` for unions, intersections, utility types
