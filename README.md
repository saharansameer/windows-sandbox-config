# 🛡️ Windows Sandbox Setup

A plug-and-play privacy sandbox for Windows 11. Opens an isolated throwaway environment with **Brave Browser** and **ProtonVPN** auto-installed on every boot. When you close it, everything inside is permanently wiped — no traces, no history, nothing.

---

## What is Windows Sandbox?

Windows Sandbox is a built-in Windows 11 feature that gives you a temporary, fully isolated copy of Windows. Think of it as a disposable PC running inside your real PC. Whatever happens inside it — browsing, downloads, installs — stays inside it. The moment you close it, it's gone forever.

---

## What does this repo do?

This repo contains a script that automatically runs inside the sandbox every time you open it. It installs:

- **Brave Browser** — privacy-focused browser with built-in ad blocking
- **ProtonVPN** — encrypted VPN to hide your internet traffic
- **Windows Defender update** — pulls the latest virus definitions so you're protected

No manual setup needed. Open the sandbox, wait a couple minutes, everything is ready.

---

## How it works

```
You double-click the .wsb file on your PC
        ↓
Windows Sandbox opens (clean, empty, isolated)
        ↓
Sandbox fetches this script from GitHub
        ↓
Script installs Brave + ProtonVPN automatically
        ↓
You browse privately and safely
        ↓
Close the sandbox = everything wiped forever
```

---

## Files in this repo

| File | What it does |
|---|---|
| `Setup-Sandbox.ps1` | The script that runs inside the sandbox and installs everything |
| `Run-MySandbox.wsb` | The config file you double-click on your PC to launch the sandbox |

---

## Requirements

- Windows 11 (Pro or Enterprise)
- Windows Sandbox enabled on your PC

**To enable Windows Sandbox:**
1. Open Start and search for *"Turn Windows features on or off"*
2. Scroll down and check **Windows Sandbox**
3. Click OK and restart your PC

---

## Setup

**1. Download the `.wsb` file** to your real PC (anywhere, your Desktop is fine)

**2. Open it** — right click → Edit it in Notepad and replace this part:
```
YOUR_USERNAME/YOUR_REPO
```
with your actual GitHub username and repo name, so the URL points to your own copy of this script.

**3. Save it and double-click it** — the sandbox will open and set itself up automatically.

---

## Security

- The sandbox is **completely isolated** from your real PC
- It cannot access your files, history, passwords, or anything on your host machine
- Malware inside the sandbox is trapped — it cannot escape to your real system
- Closing the sandbox **permanently destroys** everything inside it
- The `.wsb` file on your PC contains no sensitive information — just a public GitHub URL

