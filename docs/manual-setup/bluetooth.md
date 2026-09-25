# Bluetooth

## [ ] Pair Bluetooth devices

### Why this step is manual

SHUNYA can install Bluetooth support and enable the Bluetooth service
automatically.

Actual device pairing creates machine-specific trust and authentication
state, so pairings are intentionally not stored in Git.

---

## 1. Verify the Bluetooth service

Run:

    systemctl status bluetooth

The service should be active.

You can also check the adapter with:

    bluetoothctl show

The controller should be listed.

---

## 2. Open Bluetooth control

Start:

    bluetoothctl

Then enable the controller:

    power on

Enable the pairing agent:

    agent on
    default-agent

Start scanning:

    scan on

Wait for the required device to appear.

---

## 3. Pair the device

Find the device address shown by `bluetoothctl`.

Example:

    AA:BB:CC:DD:EE:FF

Pair:

    pair AA:BB:CC:DD:EE:FF

If prompted, confirm the pairing code on both devices.

---

## 4. Trust the device

For devices that should reconnect automatically:

    trust AA:BB:CC:DD:EE:FF

Then connect:

    connect AA:BB:CC:DD:EE:FF

Stop scanning:

    scan off

Exit:

    quit

---

## 5. Verify

List paired devices:

    bluetoothctl devices Paired

List trusted devices:

    bluetoothctl devices Trusted

Check the specific device:

    bluetoothctl info AA:BB:CC:DD:EE:FF

Look for:

    Paired: yes
    Trusted: yes
    Connected: yes

---

## Audio devices

For Bluetooth headphones or speakers, also verify PipeWire detects the
device.

Check:

    wpctl status

Confirm the Bluetooth output appears and audio can be played through it.

---

## Troubleshooting

If the adapter is blocked, check:

    rfkill list

If Bluetooth is soft-blocked:

    rfkill unblock bluetooth

If a previously paired device behaves incorrectly, remove and pair it
again:

    bluetoothctl remove AA:BB:CC:DD:EE:FF

Then repeat the pairing process.

Do not copy Bluetooth pairing databases or keys from another SHUNYA
installation.

---

## Done when

Mark this section complete when:

- [ ] Bluetooth service is active
- [ ] Bluetooth controller is available
- [ ] Required devices are paired
- [ ] Devices that should reconnect are trusted
- [ ] Devices reconnect successfully
- [ ] Bluetooth audio works through PipeWire where applicable

Bluetooth setup is complete.
