# Sound Specification

Audio, voice, vibration, and flashlight behavior for Nomad Alarm alerts.

See [Assets](ASSETS.md) for sound files and [Design System](DESIGN_SYSTEM.md) for alarm ring UI.

---

## Alert Channels

When alarm triggers, up to four channels fire simultaneously (based on user config):

1. **Sound** - ringtone or media
2. **Voice** - TTS spoken message
3. **Vibration** - haptic pattern
4. **Flashlight** - LED strobe pattern

User toggles each in Alarm Config and Settings defaults.

---

## Alarm Sounds

| ID | File | Character | Default |
|----|------|-----------|---------|
| `default` | `alarm_default.mp3` | Clear bell tone, moderate urgency | ✓ |
| `gentle` | `alarm_gentle.mp3` | Soft chime, for quiet compartments | |
| `urgent` | `alarm_urgent.mp3` | Loud piercing tone, max attention | |
| `system` | Platform default alarm | Uses Android system alarm | |
| `custom` | User-picked file | From device storage | |

### Playback Rules

| Rule | Value |
|------|-------|
| Loop | Yes, until dismiss |
| Volume | Override to max during ring (user setting) |
| Audio focus | Request `AudioFocus.gain` - duck other audio |
| Bluetooth | Route to connected device if available |
| Wired headset | Play through headset |
| Silent mode | **Still ring** (alarm stream, not media) |

Use Android alarm audio stream (`USAGE_ALARM`), not notification stream.

---

## Voice (TTS)

### Default Messages

| Locale | Template |
|--------|----------|
| EN | "Your stop is approaching. {destination} in {distance}." |
| HI | "आपका स्टॉप नज़दीक है। {destination} {distance} दूर है।" |

Custom message: user text field, max **200 characters**.

### Playback Sequence

```
1. Play TTS message (once)
2. Wait 2 sec
3. Repeat TTS (max 3 times total)
4. Sound loop continues throughout
```

TTS language from [L10N](L10N.md) settings.

---

## Vibration Patterns

Defined as `List<int>` - `[wait, vibrate, wait, vibrate, ...]` in milliseconds.

| Pattern ID | Pattern (ms) | Use |
|------------|--------------|-----|
| `default` | `[0, 800, 400, 800, 400, 800]` | Standard alarm |
| `short` | `[0, 400, 200, 400]` | Gentle |
| `long` | `[0, 1000, 500, 1000, 500, 1000]` | Urgent |
| `pulse` | `[0, 300, 150, 300, 150, 300, 150, 300]` | Rapid pulse |

Repeat vibration pattern until dismiss.

Amplitude: max (255) where supported (Android 8+).

---

## Flashlight Patterns

Requires `FLASHLIGHT` permission and hardware support.

| Pattern ID | Pattern | Use |
|------------|---------|-----|
| `off` | - | Disabled |
| `slow` | 500 ms on / 500 ms off | Default |
| `fast` | 200 ms on / 200 ms off | Urgent |
| `sos` | SOS morse pattern | Emergency optional |

Stop flashlight immediately on dismiss.

Gracefully skip if no flashlight hardware (no error shown).

---

## Snooze Behavior

| Setting | Default |
|---------|---------|
| Snooze duration | 2 min |
| Max snoozes | 3 per alarm session |

On snooze:
1. Stop sound, vibration, flashlight, TTS
2. Return alarm status → Active
3. Schedule re-trigger via exact alarm API
4. Show notification: "Snoozed - ringing again in 2 min"

---

## Notification Sounds

| Channel | Sound |
|---------|-------|
| Tracking | Silent (ongoing, no sound) |
| Alarm ring | Same as selected alarm sound |
| Warnings (GPS/battery) | System default notification sound |

---

## Smart Watch / Bluetooth

When Bluetooth audio device connected:
* Route alarm sound to watch/headphones
* Vibration still fires on phone (unless watch handles haptics - future)

---

## Implementation Notes

```dart
class AlarmAlertController {
  Future<void> trigger(Alarm alarm) async {
    if (alarm.vibrationEnabled) await Vibration.vibrate(pattern: ...);
    if (alarm.flashlightEnabled) await FlashlightPattern.start(...);
    if (alarm.voiceEnabled) await speechService.speak(...);
    await audioService.playAlarm(alarm.ringtoneUri, loop: true);
  }

  Future<void> stop() async {
    await audioService.stop();
    await Vibration.cancel();
    await FlashlightPattern.stop();
    await speechService.stop();
  }
}
```

---

## Accessibility

* Visual-only mode: flashlight + full-screen UI (no sound) for deaf users
* Haptic-only mode: vibration without sound (user setting)
* TalkBack: announce "Alarm ringing for {destination}" on ring screen focus

---

## Related Docs

* [Assets](ASSETS.md)
* [L10N](L10N.md)
* [Screens](SCREENS.md) - Alarm Ring
* [Services](SERVICES.md) - SpeechService
