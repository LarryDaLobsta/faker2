1. HTTP Framework vs Go Context

Problem:
HTTP frameworks manage request/response lifecycles, but downstream systems (DBs, APIs) need a portable way to observe cancellation and deadlines.

Decision:
Use Fiber for HTTP handling only. Use Go’s context.Context to propagate request cancellation and timeouts to downstream work.

Reasoning:
	•	Fiber’s *fiber.Ctx is framework-specific and not compatible with most Go libraries
	•	Go’s context.Context is a language-level contract understood by DB drivers, HTTP clients, etc.
	•	This keeps domain and persistence layers decoupled from the web framework

Tradeoff:
Early versions use context.Background() + timeout instead of Fiber request cancellation. This is simpler during setup and acceptable for health checks.

⸻

2. Health vs Readiness

Problem:
An application can be running but unusable if dependencies are unavailable.

Decision:
Separate liveness (/health) from readiness (/db/health).

Reasoning:
	•	/health answers: “Is the process running?”
	•	/db/health answers: “Can the app do real work right now?”

Why it matters:
This distinction becomes critical in production systems and shows an understanding of service reliability.

⸻

3. Resource Lifetimes

Observation:
Not all resources live the same length of time.

Model:
	•	DB pool → application lifetime
	•	HTTP request → short-lived
	•	context.Context → request-scoped permission to work

Principle:
Downstream work should never outlive the request that caused it.

⸻

4. Why internal/ Exists

Decision:
Place application-only packages under internal/.

Reasoning:
	•	Enforced by the Go compiler
	•	Prevents accidental reuse of app internals
	•	Keeps architectural boundaries explicit



Why this is a strong Go answer in interviews

If someone asks:

“Where do you manage database lifecycle in a Go service?”

Your answer can be:

“At the application boundary. I create the pool during startup in main, pass it into handlers, and close it on shutdown with defer. Handlers never own lifecycle.”

That shows:
	•	understanding of Go lifetimes
	•	concurrency safety
	•	production awareness