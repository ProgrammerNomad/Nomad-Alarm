# Smart Places (Saved Places)

User-facing name: **Saved Places**. Internal model: `Favorite`.

## Architecture

```
Saved Place (Favorite template)
        ↓ high confidence + 3 confirmations
   Normal Alarm (createdBy = smart)
        ↓
   History (AUTO chip)
```

All detection runs **on device**. No cloud, login, or analytics.

## Smart Alarm modes

| Mode | Behavior |
|------|----------|
| Off | No smart detection |
| Suggest | Reserved for suggestion notifications (v1 evaluates only) |
| Automatic | Creates and starts a normal alarm after travel + 90% confidence + 3 ticks |

## Confidence engine

Weighted factors: direction (35%), movement (20%), past trips (25%), distance band (10%), activity (10%). Threshold: **90%**. Debug screen shows factor breakdown.

## UI entry points

- Alarms home card (under search)
- FAB → Saved Places

## Settings

Settings → **Smart Places** section contains only the **Enable Smart Alarm** master toggle (global on/off for automatic trip detection). Manage Saved Places from the home card or FAB-not from Settings.

## Privacy

Location used only for smart detection when enabled. User can stop auto-started alarms from the notification.
