# Docker Desktop Installation Guide for Windows

## Quick Installation Steps

### 1. Download Docker Desktop

**Direct Download Link:**
https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe

Or visit: https://www.docker.com/products/docker-desktop

### 2. System Requirements

- **Windows 10/11** 64-bit: Pro, Enterprise, or Education (Build 19041 or higher)
- **WSL 2** feature enabled
- **Virtualization** enabled in BIOS
- **4GB RAM** minimum (8GB recommended)

### 3. Installation Process

1. **Run the Installer**
   - Double-click `Docker Desktop Installer.exe`
   - Accept the license agreement
   - Choose installation options:
     ✅ Use WSL 2 instead of Hyper-V (recommended)
     ✅ Add shortcut to desktop

2. **Wait for Installation**
   - Installation takes 5-10 minutes
   - May require administrator privileges

3. **Restart Computer**
   - Click "Close and restart" when prompted
   - This is required for Docker to work properly

4. **Start Docker Desktop**
   - Launch from Start Menu or Desktop shortcut
   - Wait for Docker engine to start (whale icon in system tray)
   - First launch may take 2-3 minutes

5. **Accept Terms**
   - Accept Docker Subscription Service Agreement
   - Optionally sign in (not required for local development)

### 4. Verify Installation

Open PowerShell and run:

```powershell
docker --version
docker compose version
```

Expected output:
```
Docker version 24.x.x, build xxxxxxx
Docker Compose version v2.x.x
```

### 5. Configure Docker (Optional)

In Docker Desktop settings:
- **Resources → Advanced**: Allocate CPU and RAM (2 CPUs, 4GB RAM minimum)
- **General**: Enable "Start Docker Desktop when you log in"

---

## After Docker is Installed

Once Docker is running, return to PowerShell in the EduSec directory and run:

```powershell
cd e:\EduSec
docker compose up -d
```

This will:
1. Build the PHP/Apache container (~5-10 minutes first time)
2. Download MySQL container (~2 minutes)
3. Start both containers
4. Make the application available at http://localhost:8080

---

## Troubleshooting

### WSL 2 Installation Required

If you see "WSL 2 installation is incomplete":

1. Open PowerShell as Administrator
2. Run:
   ```powershell
   wsl --install
   ```
3. Restart computer
4. Start Docker Desktop again

### Virtualization Not Enabled

If you see "Hardware assisted virtualization and data execution protection must be enabled in the BIOS":

1. Restart computer and enter BIOS (usually F2, F10, or Del key)
2. Find "Virtualization Technology" or "Intel VT-x" or "AMD-V"
3. Enable it
4. Save and exit BIOS
5. Start Docker Desktop

### Docker Desktop Won't Start

1. Ensure Windows is up to date
2. Restart Docker Desktop
3. Restart computer
4. Check Windows Event Viewer for errors

---

## Next Steps

After Docker is installed and running:

1. ✅ Run `docker compose up -d` in e:\EduSec
2. ✅ Wait for containers to start (check with `docker compose ps`)
3. ✅ Open http://localhost:8080 in browser
4. ✅ Complete EduSec installation wizard
5. ✅ Start using EduSec!

See `DOCKER_README.md` for detailed usage instructions.
