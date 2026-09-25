# Android Debugging

## [ ] Configure Android ADB access

### Why this step is manual

Android debugging authorization is tied to the physical phone and this
machine.

SHUNYA installs the required tools, but USB authorization and ADB TCP
initialization require user interaction and are therefore not stored in Git.

---

## 1. Prepare the phone

On Android, enable:

    Settings -> About phone -> Build number

Tap Build number repeatedly until Developer options are enabled.

Then enable:

    Settings -> System -> Developer options -> USB debugging

---

## 2. Authorize this SHUNYA machine

Connect the phone to the laptop using USB.

Run:

    adb devices

The phone should display an authorization prompt.

Accept the prompt.

If available, enable:

    Always allow from this computer

Run again:

    adb devices

Expected state:

    device

Not:

    unauthorized

---

## 3. Initialize classic ADB TCP mode

SHUNYA currently uses classic ADB TCP on port 5555 for:

- office Wi-Fi
- Motorola hotspot mode

With the phone connected by USB, run:

    /usr/bin/adb -d tcpip 5555

Expected output should indicate that ADB restarted in TCP mode on port 5555.

Disconnect the USB cable.

---

## 4. Test SHUNYA phone integration

Run:

    phone

The current SHUNYA launcher attempts the configured office-network phone
address first.

If that connection is unavailable, it then attempts the laptop's default
gateway for Motorola hotspot access.

---

## 5. Verify ADB state

Run:

    adb devices

A working network connection should appear similar to:

    <address>:5555    device

The exact address is machine/network-specific.

---

## 6. Test scrcpy

Run:

    phone

or test scrcpy directly if required.

SHUNYA's working audio configuration uses:

    scrcpy --audio-source=playback --audio-dup

Verify:

- phone screen appears
- input works
- audio works when supported
- disconnect/reconnect behaves correctly

---

## After a phone reboot or ADB reset

Classic ADB TCP mode may need to be initialized again.

Reconnect the phone by USB and run:

    /usr/bin/adb -d tcpip 5555

Then disconnect USB and run:

    phone

---

## Troubleshooting

If `adb devices` shows:

    unauthorized

unlock the phone and accept the USB debugging authorization prompt.

If no device appears:

1. reconnect the USB cable
2. confirm USB debugging is enabled
3. run:

       adb kill-server
       adb start-server
       adb devices

If network ADB stops working after a reboot, reinitialize TCP mode over USB.

Do not copy ADB private keys from another installation into SHUNYA.

---

## Done when

Mark this section complete when:

- [ ] USB debugging is enabled
- [ ] This SHUNYA machine is authorized
- [ ] `adb devices` shows the phone as `device`
- [ ] ADB TCP mode on port 5555 was initialized
- [ ] `phone` connects successfully
- [ ] scrcpy works
- [ ] audio works with the SHUNYA configuration where supported

Android debugging setup is complete.
