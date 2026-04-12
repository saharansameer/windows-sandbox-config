# Windows Sandbox Config

A plug-and-play privacy sandbox for Windows 11. Opens an isolated throwaway environment with custom configurations. When you close it, everything inside is permanently wiped — no traces, no history, nothing.

---

## Before you move ahead 

**This setup was created for (my) personal use only. If you plan to use it, review both the `.wsb` and `.ps1` files and modify them according to your needs.**

**The repository may change over time and could include more sandbox setups. Make sure to check the *GitHub URL* inside the `.wsb` file before running it.**

---

## Why this repo exist

This repository automates the setup of a Windows Sandbox environment. When you run `Run-MySandbox.wsb`, it automatically fetches and executes `Setup-Sandbox.ps1` inside the sandbox.

The script handles all configuration and setup tasks, making sandbox setup easier and reducing redundancy.

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

- Windows 11 <small>(Pro / Enterprise / Education)</small>
- Windows Sandbox enabled on your PC

**To enable Windows Sandbox:**
1. Open Start and search for *"Turn Windows features on or off"*
2. Scroll down and check **Windows Sandbox**
3. Click OK and restart your PC

---

## Setup

**1. Download the `.wsb` file** to your PC

**2. Double-click on it** — the sandbox will open and setup begins.

`MAKE SURE` - your system can support the following sandbox configuration:
- 8 GB RAM
- 4 CPU threads
- GPU acceleration

---