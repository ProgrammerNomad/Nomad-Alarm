# Battery Strategy

How Nomad Alarm balances **reliable alarms** with **battery efficiency**.

See [Constants](CONSTANTS.md) for numeric values and [Permissions](PERMISSIONS.md) for OEM guidance.

---

## Goals

| Goal | Target |
|------|--------|
| Idle monitoring drain | < 1% per hour |
| Alarm must not be missed due to battery saving alone | Required |
| User control | Three profiles + optional OEM exemption |

---

## Battery Profiles

### Balanced (Default)

Best for most commuters.

| Setting | Value |
|---------|-------|
| GPS interval | 5 sec |
| Distance filter | 10 m |
| Accuracy | High |
| Route refresh | Every 60 sec |
| WakeLock | Only during alarm ring |

**Use when:** Train/bus commute, typical daily use.

### Aggressive

Maximum reliability near destination.

| Setting | Value |
|---------|-------|
| GPS interval | 2 sec |
| Distance filter | 5 m |
| Accuracy | Best |
| Route refresh | Every 30 sec |
| WakeLock | During active alarm + ring |

**Use when:** Unfamiliar route, critical stop, poor GPS area.

**Auto-trigger:** App switches to Aggressive when within `2× trigger distance` of destination, even if Balanced is selected.

### Saver

Minimum battery usage.

| Setting | Value |
|---------|-------|
| GPS interval | 15 sec |
| Distance filter | 25 m |
| Accuracy | Medium |
| Route refresh | Disabled (straight-line ETA) |
| WakeLock | Only during alarm ring |

**Use when:** Long journey, battery below 30%, user preference.

**Trade-off:** Slightly delayed trigger (may ring 50–100 m later than configured).

---

## Adaptive GPS Strategy

```
                    Far from destination
                           │
                           ▼
              Use selected battery profile
                           │
                           ▼
              distance <= 2 × triggerDistance?
                           │
                    Yes ───┴─── No
                     │           │
                     ▼           ▼
              Aggressive     Keep profile
              (temporary)
                     │
                     ▼
              distance <= triggerDistance?
                     │
                     ▼
              Trigger alarm
```

---

## Background Intervals

While foreground service is running:

| Phase | Update rate | Rationale |
|-------|-------------|-----------|
| Far (> 2 km) | Profile default | Infrequent updates save battery |
| Approaching (< 2× trigger) | Aggressive | Accuracy critical |
| Stationary 5+ min | Reduce to 30 sec | User may be waiting at stop |
| Screen off | Same as above | No reduction - alarm priority |

Detect stationary: speed < 1 km/h for 5 consecutive readings.

---

## WakeLock Usage

| Scenario | WakeLock | Duration |
|----------|----------|----------|
| Normal tracking | **No** | FGS keeps process alive |
| Alarm ringing | **Yes** | Until dismiss/snooze |
| Snooze countdown | **No** | Use exact alarm API |
| GPS acquisition | **No** | Geolocator handles |

**Rule:** Never hold WakeLock during entire trip - only during alarm ring.

---

## Battery Monitoring

`BatteryService` checks:

| Level | Action |
|-------|--------|
| < 30% | Suggest Saver profile (non-blocking banner) |
| < 15% | Warning notification + suggest charging |
| Charging | No warnings; optionally suggest Aggressive |

Log events: `battery_low_warning` via [Events](EVENTS.md).

---

## Battery Optimization Exemption

Not required, but recommended on aggressive OEM ROMs (Xiaomi, Samsung, Huawei).

**UX flow:**
1. Never prompt on first launch
2. Offer in Settings → Battery after first failed background test
3. Explain trade-off clearly
4. Button opens `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` intent

---

## OEM-Specific Behaviors

| OEM | Known Issue | Mitigation |
|-----|-------------|------------|
| Samsung | Sleeping apps kill FGS | Guide: Battery → Unrestricted |
| Xiaomi | Autostart disabled | Guide: Autostart permission |
| Huawei | Background restricted | Battery optimization + manual |
| OnePlus | Battery optimization aggressive | Unrestricted setting |
| Stock Android | Generally reliable | Default flow works |

Link to [dontkillmyapp.com](https://dontkillmyapp.com) from Permission Center.

---

## Foreground Service Impact

The persistent notification is required by Android and has minimal battery cost compared to GPS.

Breakdown (typical 1-hour trip, Balanced):
* GPS: ~70–80% of alarm battery use
* FGS notification: ~5%
* Dart isolate: ~10–15%
* Network (ETA): ~5% (if online)

---

## Testing Battery

Manual tests (see [Testing](TESTING.md)):

1. 1-hour trip, Balanced - record % drain
2. 1-hour trip, Saver - compare
3. Screen off entire trip - verify trigger still works
4. Compare with battery optimization on vs off

Document results in release notes if significant change.

---

## Future Optimizations (v1.5+)

* Geofence API for far-field (low power) + GPS for near-field
* Motion detection (accelerometer) to pause updates when stationary longer
* Batch position updates when app is backgrounded

---

## Related Docs

* [Constants](CONSTANTS.md)
* [Services](SERVICES.md)
* [Permissions](PERMISSIONS.md)
* [Events](EVENTS.md)
