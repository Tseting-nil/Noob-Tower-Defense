# Noob Tower Defense — Automation Script

> [繁體中文](README.md) | **English**

Roblox *Noob Tower Defense* (PlaceId `131658557901126`)

After the user passes the **key system** verification, the API is automatically loaded into the local environment and exposes the `getgenv().NTD` interface.

- Documentation: [docs/API使用.md](docs/API使用.md) (Traditional Chinese) · [docs/API使用en.md](docs/API使用en.md) (English)

---

## 1. Load Chain / Execution Flow

```
User executes
  loadstring(game:HttpGet("https://raw.githubusercontent.com/Tseting-nil/Noob-Tower-Defense/refs/heads/main/%E5%AF%86%E9%91%B0%E7%B3%BB%E7%B5%B1.lua"))()
        │
        ▼
  KeySystem.lua  →  Validates key
        │  Passed
        ▼
  LoadMainScript.lua (NTD API) loaded into local env → creates getgenv().NTD
        │
        ├─ Lobby:    loads 介面/大廳介面.lua when needed
        ├─ In-game:  loads 介面/遊戲內介面.lua when needed
        └─ NTD.Debug(true): loads Tool/放置追蹤器.lua
```

---

## 2. Raw URL Reference

**Main Script (API)**

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Tseting-nil/Noob-Tower-Defense/refs/heads/main/%E5%AF%86%E9%91%B0%E7%B3%BB%E7%B5%B1.lua"))()
```

**Place Tracker Script**

```lua
loadstring(game:HttpGet('https://raw.githubusercontent.com/Tseting-nil/Noob-Tower-Defense/refs/heads/main/Tool/%E6%94%BE%E7%BD%AE%E8%BF%BD%E8%B9%A4%E5%99%A8.lua'))()
```

**Lobby Script**

```lua
loadstring(game:HttpGet('https://raw.githubusercontent.com/Tseting-nil/Noob-Tower-Defense/refs/heads/main/%E4%BB%8B%E9%9D%A2/%E5%A4%A7%E5%BB%B3%E4%BB%8B%E9%9D%A2.lua'))()
```

---

## 3. Related Documents

- API function usage: [docs/API使用.md](docs/API使用.md) · [docs/API使用en.md](docs/API使用en.md)
- Auto-retry mechanism (placement / upgrade / sequence): see the "Auto-Retry Mechanism" section in the usage docs
