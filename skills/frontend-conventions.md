# frontend conventions (org-level)

these are organization-wide frontend engineering conventions.
repo-specific details come from the context graph, not this file.

## component architecture

- functional components only — no class components
- one component per file, exported as default
- component directory structure:
  ```
  ComponentName/
    index.tsx          # component logic and JSX
    styles.ts          # styled-components (never inline styles)
    types.ts           # props interface and local types
    ComponentName.test.tsx  # co-located test file
  ```
- keep components under 200 lines — extract sub-components if larger
- props interface always explicitly typed (no `any`)

## state management

- Redux Toolkit is the standard — use `createSlice` for all new state
- slice directory structure:
  ```
  sliceName/
    index.ts           # createSlice definition
    types.ts           # state shape and action types
    initialState.ts    # default state values
    thunks.ts          # async operations (createAsyncThunk)
    selectors.ts       # derived state selectors
  ```
- never mutate state outside of slice reducers
- async operations always go through thunks, never in components
- use selectors for reading state — never access state shape directly in components

## styling

- styled-components for all styling — no CSS files, no inline styles
- use design tokens from the theme (colors, spacing, typography)
- never hardcode colors, font sizes, or spacing values
- responsive design: mobile-first approach
- keep styles in a separate `styles.ts` file, not inline in the component

## testing

- Jest + React Testing Library
- test behavior from the user's perspective, not implementation details
- test file co-located with component: `ComponentName.test.tsx`
- minimum expectations for new components:
  - renders without crashing
  - displays expected content
  - responds to user interactions (clicks, input)
  - handles error states
- mock external dependencies (API calls, Firebase), never mock the component itself

## imports and dependencies

- absolute imports preferred over deep relative paths
- group imports: react/libs first, then internal modules, then local files
- no circular dependencies between modules
- tree-shake: import specific functions, not entire libraries

## accessibility

- all interactive elements must be keyboard accessible
- images need alt text
- form inputs need labels
- color contrast must meet WCAG AA standards
- use semantic HTML elements (button, nav, main, section)

## error handling

- all async operations must have error handling (try/catch or .catch)
- user-facing errors must have friendly messages (not stack traces)
- unexpected errors caught by error boundaries at the page level
- error states should suggest what the user can do next
