# Diagrams

Visual reference for architecture, flows, state, and project structure. Rendered as Mermaid in GitHub and most Markdown viewers.

---

## 1. Layer Architecture (with Repository)

```mermaid
flowchart TB
    subgraph Presentation
        UI[Screens & Widgets]
    end

    subgraph Application
        CTRL[Controllers / Notifiers]
    end

    subgraph Domain
        MODELS[Models & Enums]
        REPO[Repositories]
    end

    subgraph Infrastructure
        SVC[Services]
        PROV[Providers - Map/Search/Route]
        DB[(Isar DB)]
        API[External APIs]
    end

    UI --> CTRL
    CTRL --> REPO
    REPO --> MODELS
    REPO --> SVC
    SVC --> PROV
    SVC --> DB
    PROV --> API
```

---

## 2. Alarm Trigger Sequence

```mermaid
sequenceDiagram
    actor User
    participant AC as AlarmController
    participant AR as AlarmRepository
    participant LS as LocationService
    participant AS as AlarmService
    participant NS as NotificationService
    participant SS as SpeechService
    participant UI as AlarmRingScreen

    User->>AC: Save & Start alarm
    AC->>AR: startAlarm(id)
    AR->>AS: startMonitoring(alarm)
    AR->>LS: watchPosition()
    AS->>NS: showTrackingNotification()

    loop Every GPS update
        LS->>AS: onPosition(position)
        AS->>AS: evaluate distance
        AS->>NS: updateTrackingNotification()
    end

    Note over AS: distance <= threshold
    AS->>NS: showAlarmRingNotification()
    AS->>SS: speak(message)
    NS->>UI: full screen intent
    User->>UI: Dismiss
    UI->>AC: dismissAlarm(id)
    AC->>AR: completeAlarm(id)
    AR->>AS: stopMonitoring()
    AR->>NS: cancelAll()
```

---

## 3. Search & Create Alarm Sequence

```mermaid
sequenceDiagram
    actor User
    participant SC as SearchController
    participant SR as SearchRepository
    participant SP as SearchProvider
    participant AC as AlarmController
    participant AR as AlarmRepository

    User->>SC: type query
    SC->>SR: search(query)
    SR->>SP: forwardGeocode(query)
    SP-->>SR: SearchResult[]
    SR-->>SC: results
    User->>SC: select destination
    SC->>AC: openAlarmConfig(result)
    User->>AC: Save & Start
    AC->>AR: createAndStart(draft)
    AR-->>AC: Alarm
```

---

## 4. Alarm State Diagram

```mermaid
stateDiagram-v2
    [*] --> Draft: Create alarm
    Draft --> Active: Start
    Draft --> [*]: Delete

    Active --> Paused: Pause
    Paused --> Active: Resume
    Active --> Cancelled: Cancel
    Paused --> Cancelled: Cancel

    Active --> Triggered: Threshold reached
    Paused --> Triggered: Threshold reached (if enabled)

    Triggered --> Completed: Dismiss
    Triggered --> Active: Snooze
    Triggered --> Missed: Timeout / no response

    Active --> Missed: App killed / GPS fail (policy)
    Cancelled --> [*]
    Completed --> History: Log entry
    Missed --> History: Log entry
    History --> [*]
```

---

## 5. Trip Lifecycle State

```mermaid
stateDiagram-v2
    [*] --> InProgress: Alarm started
    InProgress --> Completed: Dismiss at destination
    InProgress --> Cancelled: User cancel
    InProgress --> Missed: Passed / failed
    Completed --> [*]
    Cancelled --> [*]
    Missed --> [*]
```

---

## 6. Database Entity Relationships

```mermaid
erDiagram
    Alarm ||--o| Trip : "has active"
    Alarm ||--o{ HistoryEntry : generates
    Trip ||--o{ HistoryEntry : linked
    Favorite ||--o{ RecentSearch : "may overlap"
    AppSettings ||--|| AppSettings : singleton

    Alarm {
        int id PK
        string name
        double destLatitude
        double destLongitude
        enum status
        enum travelMode
    }

    Trip {
        int id PK
        int alarmId FK
        datetime startedAt
        enum outcome
    }

    Favorite {
        int id PK
        string name
        enum category
    }

    HistoryEntry {
        int id PK
        int alarmId FK
        enum type
        datetime occurredAt
    }
```

---

## 7. Folder Structure

```mermaid
flowchart LR
    subgraph lib
        main[main.dart]
        core[core/]
        features[features/]
        models[models/]
        repos[repositories/]
        services[services/]
        providers[providers/]
        shared[shared/widgets/]
        theme[theme/]
    end

    features --> home[home/]
    features --> alarm[alarm/]
    features --> map[map/]
    features --> search[search/]
    features --> settings[settings/]
```

---

## 8. Riverpod Provider Tree (Simplified)

```mermaid
flowchart TD
    APP[appProviders]

    APP --> LS[locationServiceProvider]
    APP --> AS[alarmServiceProvider]
    APP --> NS[notificationServiceProvider]
    APP --> SS[settingsServiceProvider]

    APP --> AR[alarmRepositoryProvider]
    APP --> SR[searchRepositoryProvider]
    APP --> TR[tripRepositoryProvider]

    AR --> AS
    AR --> LS
    SR --> searchProviderFactory
    TR --> isarProvider

    AC[alarmControllerProvider] --> AR
    SC[searchControllerProvider] --> SR
    HC[homeControllerProvider] --> AR
    HC --> SR

    ACTIVE[activeAlarmStreamProvider] --> AR
```

---

## 9. Service Layer Dependencies

```mermaid
flowchart TD
    PS[PermissionService]
    LS[LocationService]
    AS[AlarmService]
    NS[NotificationService]
    TTS[SpeechService]
    BS[BatteryService]
    RS[RouteService]
    MS[MapService]
    SS[SettingsService]
    BK[BackupService]

    PS --> LS
    LS --> AS
    AS --> NS
    AS --> TTS
    AS --> RS
    AS --> BS
    SS --> MS
    SS --> RS
    BK --> SS
```

---

## 10. Permission Onboarding Flow

```mermaid
flowchart TD
    A[Welcome] --> B[Location - While In Use]
    B --> C{Granted?}
    C -->|Yes| D[Notifications]
    C -->|No| E[Explain + Retry / Settings]
    E --> B
    D --> F{Granted?}
    F -->|Yes| G[Background Location]
    F -->|No| H[Limited mode warning]
    G --> I[Home]
    H --> I
```

---

## 11. Offline Fallback Flow

```mermaid
flowchart TD
    REQ[User action needs network]
    REQ --> CHECK{Online?}
    CHECK -->|Yes| API[Call provider API]
    CHECK -->|No| CACHE{Cache available?}
    API --> OK[Return result]
    API --> FAIL{Failed?}
    FAIL -->|Yes| CACHE
    FAIL -->|No| OK
    CACHE -->|Yes| CACHED[Return cached data]
    CACHE -->|No| FALLBACK[Straight-line / coords-only fallback]
```

---

## Related Docs

* [Architecture](ARCHITECTURE.md)
* [User Flows](USER_FLOWS.md)
* [Database](DATABASE.md)
* [Services](SERVICES.md)
