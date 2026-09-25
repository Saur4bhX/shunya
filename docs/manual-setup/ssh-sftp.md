# SSH / SFTP

## [ ] Configure SSH and SFTP access

### Why this step is manual

SHUNYA can install OpenSSH and enable `sshd`, but authentication credentials,
SSH keys and remote-device configuration are private machine-specific state.

They must not be stored in the SHUNYA repository.

---

## 1. Verify the SSH server

Run:

    systemctl status sshd

The service should be active.

Check that SSH is listening:

    ss -ltn | grep ':22'

---

## 2. Find this machine's network address

Run:

    ip -brief address

Look for the active Wi-Fi or Ethernet interface.

Example:

    wlan0    UP    192.168.1.50/24

The address will vary between networks.

---

## 3. Test locally

Run:

    ssh localhost

Accept the host key when prompted.

Authenticate using the configured login method.

Exit with:

    exit

---

## 4. Configure SFTP on another device

On the phone or another computer, create an SFTP connection.

Use:

    Protocol: SFTP
    Host: <SHUNYA-IP>
    Port: 22
    Username: <SHUNYA-USERNAME>

Use the authentication method configured for this machine.

Do not save passwords or private keys inside the SHUNYA repository.

---

## 5. Verify SFTP

From another Linux machine, you can test with:

    sftp <username>@<SHUNYA-IP>

After connecting:

    ls

Try transferring a harmless test file.

---

## 6. SSH keys

If key-based authentication is preferred, generate a key on the client
device rather than copying private keys from another SHUNYA installation.

Example on a Linux client:

    ssh-keygen -t ed25519

Copy only the public key:

    ssh-copy-id <username>@<SHUNYA-IP>

The private key must remain on the client device.

---

## 7. Check authorized keys

On SHUNYA:

    ls -la ~/.ssh

If key authentication is configured, authorized public keys are normally
stored in:

    ~/.ssh/authorized_keys

Recommended permissions:

    chmod 700 ~/.ssh
    chmod 600 ~/.ssh/authorized_keys

Never commit this directory or private authentication material to Git.

---

## 8. Verify from the intended client

Test SSH:

    ssh <username>@<SHUNYA-IP>

Test SFTP:

    sftp <username>@<SHUNYA-IP>

Verify that the user can access the expected files.

---

## Troubleshooting

Check the service:

    systemctl status sshd

Check recent logs:

    journalctl -u sshd -b

Check whether port 22 is listening:

    ss -ltn | grep ':22'

Check the current IP address:

    ip -brief address

If the IP changes after reconnecting to Wi-Fi, update the SFTP client with
the current address.

---

## Security notes

- Never commit SSH private keys.
- Never commit passwords.
- Never commit `authorized_keys` as portable SHUNYA configuration.
- Do not expose SSH directly to the public Internet without intentionally
  configuring appropriate security and network controls.
- Prefer key-based authentication when practical.

---

## Done when

Mark this section complete when:

- [ ] `sshd` is active
- [ ] Port 22 is listening
- [ ] Local SSH login works
- [ ] Intended external device can connect
- [ ] SFTP file access works
- [ ] Authentication credentials remain outside Git

SSH/SFTP setup is complete.
