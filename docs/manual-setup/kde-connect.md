# KDE Connect

## [ ] Pair phone with SHUNYA

### Why this step is manual

KDE Connect pairing information and private device identity are
machine-specific and are intentionally not stored in Git.

SHUNYA can install and start the required software, but a new machine must
be paired with the phone manually.

---

## 1. Prepare both devices

Install KDE Connect on the phone.

Make sure the phone and SHUNYA machine are connected to the same network.

They must be able to reach each other directly.

---

## 2. Check KDE Connect on SHUNYA

Run:

    kdeconnect-cli -l

Nearby devices should appear.

If the phone appears as unpaired, continue to the next step.

---

## 3. Send a pairing request

First find the device ID:

    kdeconnect-cli -l

Then request pairing:

    kdeconnect-cli --pair --device <DEVICE-ID>

Alternatively, send the pairing request from the KDE Connect application
on the phone.

Accept the request on the other device.

---

## 4. Verify pairing

Run:

    kdeconnect-cli -l

The phone should now appear as paired and reachable.

You can also inspect the device with:

    kdeconnect-cli --device <DEVICE-ID> --list-available

---

## 5. Test basic integration

Test at least one useful KDE Connect function, such as:

- sending a file
- clipboard sharing
- notifications
- media control
- battery information

Only enable plugins you actually intend to use.

---

## Troubleshooting

If the phone is not detected:

1. Confirm both devices are on the same network.
2. Confirm KDE Connect is running on the phone.
3. Disable VPN isolation temporarily if it prevents local-device discovery.
4. Check that the network does not block communication between clients.
5. Run again:

       kdeconnect-cli -l

Pairing must not be copied from another SHUNYA installation.

---

## Done when

Mark this section complete when:

- [ ] KDE Connect is installed on both devices
- [ ] Phone and laptop can discover each other
- [ ] Pairing request was accepted
- [ ] `kdeconnect-cli -l` shows the phone as paired
- [ ] At least one KDE Connect feature was tested successfully

KDE Connect setup is complete.

