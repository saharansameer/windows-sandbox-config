# Windows Sandbox Config

A Windows Sandbox configuration that retrieves and executes a PowerShell script inside Windows Sandbox to convert the instance into a preconfigured working environment.

---

## How it works

```
Double-click the .wsb file on your PC
        ↓
Windows Sandbox opens (clean, empty, isolated)
        ↓
Sandbox fetches the '.ps1' script from this repository
        ↓
Script start executing inside the sandbox
        ↓
Wait (few moments) for the script to finish
        ↓
Sandbox is ready to use
```

---

## Files

| Name | Description |
|---|---|
| `Setup-Sandbox.ps1` | Runs inside the sandbox. Handles configuration and installs. |
| `Run-MySandbox.wsb` | The config file you double-click on your PC to launch the sandbox. |

---

## Setup

**Step 1: Check System Requirements**

You must have one of the following editions of **Windows 11**:
- Pro
- Enterprise
- Education

Sandbox is configured to use the following resources, make sure your PC can support them:
- 8 GB RAM (8192 *MegaBytes*)
- 4 vCPU threads

> The default sandbox allocates 4 GB RAM and 2 vCPU. This config overrides those defaults.

**Step 2: Enable Windows Sandbox**
1. Open Start and search for *"Turn Windows features on or off"*
2. Scroll down and check **Windows Sandbox**
3. Click OK and restart your PC

**Step 3: Run**
> **Note:** Review both the `.wsb` and `.ps1` files before moving forward, and modify them to fit your needs.

1. Download the `.wsb` file to your PC
2. Double-click it and wait for the sandbox to boot

---