# NTFS / Windows Volumes

## [ ] Configure automatic NTFS mounts

### Why this step is manual

Disk UUIDs, partition labels and desired mount points differ between machines.

SHUNYA therefore detects NTFS filesystems but does not automatically modify
`/etc/fstab`.

---

## 1. Identify NTFS volumes

Run:

    lsblk -f

Example:

    NAME   FSTYPE LABEL UUID
    sda3   ntfs         ABCD1234
    sda4   ntfs   work  EFGH5678

Decide which NTFS partitions should mount automatically.

Do not use device names such as:

    /dev/sda3

Device names can change.

Always use the filesystem UUID.

---

## 2. Check your user ID

Run:

    id -u
    id -g

Typical output:

    1000
    1000

Use the actual values shown on this machine.

---

## 3. Choose mount points

Example:

    /mnt/windows
    /mnt/edu
    /mnt/work
    /mnt/mul

Create the required directories:

    sudo mkdir -p /mnt/windows
    sudo mkdir -p /mnt/edu
    sudo mkdir -p /mnt/work
    sudo mkdir -p /mnt/mul

Only create mount points for volumes you actually intend to use.

---

## 4. Configure `/etc/fstab`

Open:

    sudo vim /etc/fstab

Add one line for each NTFS filesystem.

Template:

    UUID=<UUID>  /mnt/<name>  ntfs3  rw,uid=<UID>,gid=<GID>,umask=022,nofail  0  0

Example:

    UUID=ABCDEF1234567890  /mnt/work  ntfs3  rw,uid=1000,gid=1000,umask=022,nofail  0  0

Meaning:

- `ntfs3` — Linux kernel NTFS driver
- `rw` — read/write access
- `uid` — normal user ownership
- `gid` — normal user's group
- `umask=022` — owner can write; others can read
- `nofail` — boot continues if the volume is unavailable

---

## 5. Test before rebooting

Run:

    sudo mount -a

There should be no errors.

Then check mounted NTFS filesystems:

    findmnt -t ntfs3

---

## 6. Test read/write access

Choose one mounted volume.

Example:

    touch /mnt/work/shunya-write-test
    rm /mnt/work/shunya-write-test

Both commands should work without `sudo`.

---

## 7. Reboot verification

Reboot:

    systemctl reboot

After login:

    findmnt -t ntfs3

Confirm that all intended NTFS volumes mounted automatically.

---

## Windows requirement

When a Windows installation shares these NTFS filesystems, Windows Fast
Startup and hibernation must be disabled before routinely mounting those
filesystems read/write from Linux.

Do not force-write to a Windows filesystem that Linux reports as being in
an unsafe or hibernated state.

---

## Done when

Mark this section complete when:

- [ ] Correct NTFS volumes were identified
- [ ] UUIDs are used instead of `/dev/sdX`
- [ ] Mount points exist
- [ ] `/etc/fstab` entries are valid
- [ ] `sudo mount -a` reports no errors
- [ ] Normal user has read/write access
- [ ] Volumes mount automatically after reboot

NTFS setup is complete.
