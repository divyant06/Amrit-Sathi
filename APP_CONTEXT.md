# 🧭 Amrit Sathi - Core Architecture & AI Context Engine
> **File Version:** 2.0.0  
> **Target Milestones:** Field Test (July 18, 2026) | GSSoC Launch (July 22, 2026) | Play Store Release (Mid-August 2026)  
> **Architecture Principle:** Offline-First, Agent-Driven Cross-Platform Architecture.

---

## 🏗️ 1. Core System Architecture

Amrit Sathi is built using an offline-first architecture optimized for zero-budget scalability, low latency, and future web portability. The stack decouples the user interface from data processing to allow smooth multi-platform delivery.

```text
┌─────────────────────────────────────────────────────────────┐
│                     Flutter UI Layer                        │
│         (Explore Map / Co-Pilot Chat / Story Feed)          │
└───────────────▲─────────────────────────────▲───────────────┘
                │                             │
    Riverpod State Management      gmp-code-assist (Maps API)
                │                             │
┌───────────────▼─────────────────────────────▼───────────────┐
│                    Data Management Layer                    │
│  ┌──────────────────────────────┐ ┌──────────────────────┐  │
│  │ Hive Local Storage (Offline) │ │ Supabase Client (WS) │  │
│  └──────────────────────────────┘ └──────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### 🧠 State Management: Riverpod
* **Role:** Serves as the global application state coordinator. All features (Auth, Map Camera position, active Squad members) stream their state via Riverpod Providers.
* **Web Portability:** UI code remains decoupled from logic. To build the companion web app later, the same Riverpod business logic will be reused completely without rewriting code.

### 📦 Local Persistence: Hive
* **Role:** High-speed, lightweight NoSQL key-value database running directly on the local file system. 
* **Offline Execution Strategy:** Essential for the Meghalaya field test. The application reads user metadata, cached itineraries, and bucket list objects out of Hive first. If a network connection is detected, the change asynchronously syncs up to the cloud.

### ☁️ Cloud Infrastructure: Supabase (Free Tier Optimization)
* **Role:** Central database, real-time WebSocket synchronization matrix, image asset hosting, and secure authentication.
* **Scalability Matrix:**
  * **Database:** PostgreSQL handling profile indexing, squad tables, and spatial geometries.
  * **Realtime Engine:** Broadcasts user LatLng points via secure WebSockets to display matching squad markers seamlessly.
  * **Storage Buckets:** Caches images for the travel "Story & Reels UI" using public edge CDN endpoints.

---

## 🤖 2. AI Architecture: Open Agent Framework (OAF)

Instead of maintaining resource-heavy, multi-stage Retrieval-Augmented Generation (RAG) infrastructure, Amrit Sathi leverages the native **1-to-2 Million Token Context Window** of Google Gemini via `google_generative_ai`.

### OAF Operational Pipeline
1. **Holistic Context Ingestion:** When initializing the Co-Pilot chat, the application injects a structured system prompt containing the complete structural system rules, dynamic app state parameters (current location, system light/dark mode configuration), and an embedded JSON dictionary of travel hubs.
2. **Contextual Intent Tracking:** The AI handles user queries holistically rather than breaking them down into small textual pieces.
3. **App Control & Tool Execution:** When the agent detects an action statement (e.g., *"Take me to Guwahati"*), it generates a structured JSON block inside its hidden execution envelope:
   ```json
   {
     "intent": "NAVIGATE_MAP",
     "target_city": "Guwahati",
     "coordinates": {"lat": 26.1445, "lng": 91.7363}
   }
   ```
4. **UI Response Execution:** The Riverpod layer catches this output sequence, programmatically alters the `BottomNavigationBar` view index to the Map page, and commands the `MapController` to execute a camera flight path.

---

## 🗺️ 3. Google Maps SDK & GPS Integration

* **Package Strategy:** Managed via `Maps_flutter` and `geolocator`.
* **GPS Pipeline:** The app tracks geographic positions on a background thread utilizing the device's hardware location subsystem. 
* **Dynamic Markers:** The `GoogleMap` container renders distinct layers:
  1. **User Location:** Real-time hardware telemetry point.
  2. **Squad Matrix:** Dynamic markers populated by active real-time channels listening to Supabase.
  3. **Meetup Destination:** A single high-visibility marker that renders only if a `meetupLocation` LatLng state variable is populated.

---

## 🎮 4. Gamification & System Storage Schemas

To maintain user retention and drive engagement, the app implements explicit user leveling database records.

### 🗄️ Database Table: `profiles`
| Column Name | Data Type | Constraints / Description |
| :--- | :--- | :--- |
| `id` | `uuid` | Primary Key (References `auth.users`) |
| `username` | `text` | Unique display identifier |
| `current_level`| `int4` | Default: `1` (User Class: Wanderer) |
| `experience_points` | `int4` | Accumulated user progression score |
| `badges_unlocked` | `text[]` | Array strings matching earned badge assets |

### 🗄️ Database Table: `squad_sessions`
| Column Name | Data Type | Constraints / Description |
| :--- | :--- | :--- |
| `squad_code` | `text` | Primary Key (Unique 6-digit session string) |
| `created_by` | `uuid` | References squad creator profile |
| `meetup_lat` | `float8` | Shared destination latitude marker |
| `meetup_lng` | `float8` | Shared destination longitude marker |
| `created_at` | `timestamptz`| Automounted operational execution timestamp |

---

## ⚙️ 5. AI Workspace & MCP Server Execution Playbook

This project interfaces directly with local Model Context Protocol (MCP) toolchains. AI agents must follow these explicit rules when using tools:

### 🛠️ Active MCP Server Mappings

| MCP Server Name | Native System Capabilities | Engineering Workflow Integration |
| :--- | :--- | :--- |
| **`gmp-code-assist`** | Google Maps Platform API design guidelines and optimal route functions. | Use this server explicitly when modifying camera flight configurations, drawing paths on the map, or parsing geo-telemetry. |
| **`supabase`** | Introspects database models, table properties, and access validation paths. | Invoke this server whenever modifying local query functions or structuring real-time PostgreSQL pipelines. |
| **`dart-mcp-server`** | Evaluates Dart compilation errors and checks Riverpod implementation styles. | Run this to enforce structural syntax consistency and fix widget tree state propagation failures. |
| **`sequential-thinking`**| Provides architectural analysis steps before modifying code layers. | Must be executed before running deep multi-file updates to prevent breaking dependent code layers. |
| **`github-mcp-server`**| Syncs issues, tracks project tags, and formats structural check steps. | Use this from July 22nd onward to assign tasks, label tickets, and review PRs for GSSoC contributors. |
| **`android-cli`** | Compiles debug APK variants and checks native build configurations. | Run this to check build pipelines and verify native Android builds before deployment steps. |

### 🚫 Strict Agent Constraints
* **No Code Erasure:** Never prune existing custom dark-mode UI elements (`#0B1120`) or structural widgets to solve a logic problem. Use `sequential-thinking` to plan workarounds.
* **Environment Integrity:** Never write raw text API credentials or keys into any file. All keys must be parsed exclusively via `flutter_dotenv`.
* **State Boundaries:** Do not merge UI view builders with underlying infrastructure operations. All changes must respect the Riverpod architecture.