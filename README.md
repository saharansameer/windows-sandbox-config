# Windows Sandbox Config

A custom Windows Sandbox setup that automatically pulls and runs the required setup script inside the isolated session. It handles all configuration steps without manual setup, simplifying the process and reducing redundancy.

---

## Before you move ahead 

This setup was created for (my) personal use only. If you plan to use it, review both the `.wsb` and `.ps1` files and modify them according to your needs.

The repository may change over time and could include more sandbox setups. Make sure to check the *GitHub URL* inside the `.wsb` file before running it.

---

## How it works

```
You double-click the .wsb file on your PC
        ↓
Windows Sandbox opens (clean, empty, isolated)
        ↓
Sandbox fetches the '.ps1' script from this repository
        ↓
Script executes inside the sandbox
        ↓
Sandbox is ready to use
        ↓
Close the sandbox = everything wiped forever
```

---

## File Structure

| File | What it does |
|---|---|
| `Setup-Sandbox.ps1` | The script that runs inside the sandbox and installs everything |
| `Run-MySandbox.wsb` | The config file you double-click on your PC to launch the sandbox |

---

## Requirements

- Windows 11 (Pro / Enterprise / Education)
- Windows Sandbox enabled on your PC

**To enable Windows Sandbox:**
1. Open Start and search for *"Turn Windows features on or off"*
2. Scroll down and check **Windows Sandbox**
3. Click OK and restart your PC

---

## Setup

**1. Download the `.wsb` file** to your PC

**2. Double-click on it** — wait for a while, and the sandbox will be ready to use.

**MAKE SURE** - your system can support the following sandbox configuration:
- 8 GB RAM
- 4 vCPU threads

Note: Default sandbox values are *4 GB RAM* and *2 vCPU*. These have been changed based on my needs.

---
