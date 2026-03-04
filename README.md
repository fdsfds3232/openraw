<div align="center">

```
 ██████╗ ██████╗ ███████╗███╗   ██╗██████╗  █████╗ ██╗    ██╗
██╔═══██╗██╔══██╗██╔════╝████╗  ██║██╔══██╗██╔══██╗██║    ██║
██║   ██║██████╔╝█████╗  ██╔██╗ ██║██████╔╝███████║██║ █╗ ██║
██║   ██║██╔═══╝ ██╔══╝  ██║╚██╗██║██╔══██╗██╔══██║██║███╗██║
╚██████╔╝██║     ███████╗██║ ╚████║██║  ██║██║  ██║╚███╔███╔╝
 ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚══╝╚══╝
```

**The Agent Operating System**

Open-source Agent OS built in Rust — 137K LOC · 14 crates · 1,767+ tests · Zero clippy warnings

*One binary. Battle-tested. Agents that actually work for you.*

[![Rust](https://img.shields.io/badge/language-Rust-000000?style=flat-square&labelColor=000000&color=ffffff)](https://www.rust-lang.org/)
[![MIT](https://img.shields.io/badge/license-MIT-000000?style=flat-square&labelColor=000000&color=ffffff)](LICENSE-MIT)
[![v0.1.0](https://img.shields.io/badge/version-0.1.0-000000?style=flat-square&labelColor=000000&color=ffffff)](https://github.com/your-username/openraw/releases)
[![Tests](https://img.shields.io/badge/tests-1%2C767%2B%20passing-000000?style=flat-square&labelColor=000000&color=ffffff)](https://github.com/your-username/openraw/actions)

</div>

---

> **v0.1.0 — First Release (March 2026)**
>
> OpenRaw is feature-complete but this is the first public release. You may encounter instability or breaking changes between minor versions. We ship fast and fix fast. [Report issues here.](https://github.com/your-username/openraw/issues)

---

## Install

**Linux / macOS**

```bash
curl -sSf https://raw.githubusercontent.com/your-username/openraw/main/install.sh | sh
openraw init
openraw start
# Dashboard → http://localhost:4200
```

**Windows (PowerShell)**

```powershell
irm https://raw.githubusercontent.com/your-username/openraw/main/install.ps1 | iex
openraw init
openraw start
```

**From source**

```bash
cargo install --git https://github.com/your-username/openraw openraw-cli
```

---

## What is OpenRaw?

OpenRaw is an **open-source Agent Operating System** — not a chatbot wrapper, not a Python orchestrator. It is a full operating system for autonomous agents, built from scratch in Rust.

Traditional agent frameworks wait for you to type something. OpenRaw runs **autonomous agents that work for you** — on schedules, 24/7, building knowledge graphs, monitoring targets, generating leads, managing your social media, and reporting results to your dashboard.

The entire system compiles to a **single ~32MB binary**. One install. One command. Your agents are live.

---

## Hands — Autonomous Capability Packages

**Hands** are OpenRaw's core innovation — pre-built autonomous modules that run independently, on schedules, without prompting. This is not a chatbot. This is an agent that wakes up at 6 AM, researches your competitors, builds a knowledge graph, scores the findings, and delivers a report before you've had coffee.

Each Hand bundles a system prompt, skill reference, tool manifest, and guardrails — compiled directly into the binary. No downloading, no pip install, no Docker pull.

| Hand | What It Does |
|------|-------------|
| **Clip** | YouTube → vertical shorts with captions and thumbnails. 8-phase pipeline. FFmpeg + yt-dlp + 5 STT backends. |
| **Lead** | Daily prospect discovery. Enriches, scores 0–100, deduplicates, delivers qualified leads in CSV/JSON/Markdown. |
| **Collector** | OSINT-grade intelligence. Monitors continuously — change detection, sentiment tracking, knowledge graph construction. |
| **Predictor** | Superforecasting engine. Calibrated reasoning chains, confidence intervals, Brier score accuracy tracking. |
| **Researcher** | Deep autonomous researcher. CRAAP-criteria source evaluation, cited reports, multi-language support. |
| **Twitter** | Autonomous X account manager. 7 rotating content formats, approval queue — nothing posts without your OK. |
| **Browser** | Web automation. Navigates sites, fills forms, handles workflows. Mandatory purchase approval gate. |

```bash
openraw hand activate researcher   # starts working immediately
openraw hand status researcher
openraw hand activate lead
openraw hand list
```

---

## Architecture

14 Rust crates. 137,728 lines of code. Modular kernel design.

```
openraw-kernel      Orchestration, workflows, metering, RBAC, scheduler, budget tracking
openraw-runtime     Agent loop, 3 LLM drivers, 53 tools, WASM sandbox, MCP, A2A
openraw-api         140+ REST/WS/SSE endpoints, OpenAI-compatible API, dashboard
openraw-channels    40 messaging adapters with rate limiting, DM/group policies
openraw-memory      SQLite persistence, vector embeddings, canonical sessions, compaction
openraw-types       Core types, taint tracking, Ed25519 manifest signing, model catalog
openraw-skills      60 bundled skills, SKILL.md parser, Hub marketplace
openraw-hands       7 autonomous Hands, HAND.toml parser, lifecycle management
openraw-extensions  25 MCP templates, AES-256-GCM credential vault, OAuth2 PKCE
openraw-wire        OFP P2P protocol with HMAC-SHA256 mutual authentication
openraw-cli         CLI with daemon management, TUI dashboard, MCP server mode
openraw-desktop     Tauri 2.0 native app (system tray, notifications, global shortcuts)
openraw-migrate     OpenClaw, LangChain, AutoGPT migration engine
xtask               Build automation
```

---

## Benchmarks

All data from official documentation and public repositories — March 2026.

#### Cold Start Time (lower is better)

```
ZeroClaw   ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░   10 ms
OpenRaw    ██████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  180 ms    ★
LangGraph  █████████████████░░░░░░░░░░░░░░░░░░░░░░░░░  2.5 sec
CrewAI     ████████████████████░░░░░░░░░░░░░░░░░░░░░░  3.0 sec
AutoGen    ██████████████████████████░░░░░░░░░░░░░░░░░  4.0 sec
OpenClaw   █████████████████████████████████████████░░  5.98 sec
```

#### Idle Memory (lower is better)

```
ZeroClaw   █░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    5 MB
OpenRaw    ████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░   40 MB    ★
LangGraph  ██████████████████░░░░░░░░░░░░░░░░░░░░░░░░░  180 MB
CrewAI     ████████████████████░░░░░░░░░░░░░░░░░░░░░░░  200 MB
AutoGen    █████████████████████████░░░░░░░░░░░░░░░░░░  250 MB
OpenClaw   ████████████████████████████████████████░░░░  394 MB
```

#### Install Size (lower is better)

```
ZeroClaw   █░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  8.8 MB
OpenRaw    ███░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░   32 MB    ★
CrewAI     ████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  100 MB
LangGraph  ████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  150 MB
AutoGen    ████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░  200 MB
OpenClaw   ████████████████████████████████████████░░░░  500 MB
```

---

## Feature Comparison

| Feature | **OpenRaw** | OpenClaw | ZeroClaw | CrewAI | AutoGen | LangGraph |
|---------|-------------|----------|----------|--------|---------|-----------|
| Language | **Rust** | TypeScript | Rust | Python | Python | Python |
| Autonomous Hands | **7 built-in** | None | None | None | None | None |
| Security Layers | **16 discrete** | 3 basic | 6 layers | 1 basic | Docker | AES enc. |
| Agent Sandbox | **WASM dual-metered** | None | Allowlists | None | Docker | None |
| Channel Adapters | **40** | 13 | 15 | 0 | 0 | 0 |
| Built-in Tools | **53 + MCP + A2A** | 50+ | 12 | Plugins | MCP | LC tools |
| Memory | **SQLite + vector** | File-based | SQLite FTS5 | 4-layer | External | Checkpoints |
| Desktop App | **Tauri 2.0** | None | None | None | Studio | None |
| Audit Trail | **Merkle hash-chain** | Logs | Logs | Tracing | Logs | Checkpoints |
| Cold Start | **<200ms** | ~6s | ~10ms | ~3s | ~4s | ~2.5s |
| Install Size | **~32 MB** | ~500 MB | ~8.8 MB | ~100 MB | ~200 MB | ~150 MB |
| License | MIT | MIT | MIT | MIT | Apache 2.0 | MIT |

---

## 16 Security Layers

| # | System | What It Does |
|---|--------|-------------|
| 1 | **WASM Dual-Metered Sandbox** | Tool code runs in WebAssembly with fuel metering + epoch interruption. A watchdog thread kills runaway code. |
| 2 | **Merkle Hash-Chain Audit Trail** | Every action is cryptographically linked to the previous one. Tamper with one entry and the chain breaks. |
| 3 | **Information Flow Taint Tracking** | Labels propagate through execution — secrets tracked from source to sink. |
| 4 | **Ed25519 Signed Agent Manifests** | Every agent identity and capability set is cryptographically signed. |
| 5 | **SSRF Protection** | Blocks private IPs, cloud metadata endpoints, and DNS rebinding attacks. |
| 6 | **Secret Zeroization** | `Zeroizing<String>` auto-wipes API keys from memory the instant they're no longer needed. |
| 7 | **OFP Mutual Authentication** | HMAC-SHA256 nonce-based, constant-time verification for P2P networking. |
| 8 | **Capability Gates** | Role-based access control — agents declare required tools, kernel enforces it. |
| 9 | **Security Headers** | CSP, X-Frame-Options, HSTS, X-Content-Type-Options on every response. |
| 10 | **Health Endpoint Redaction** | Public health check returns minimal info. Full diagnostics require auth. |
| 11 | **Subprocess Sandbox** | `env_clear()` + selective variable passthrough. Process tree isolation. |
| 12 | **Prompt Injection Scanner** | Detects override attempts, data exfiltration patterns, and shell injection in skills. |
| 13 | **Loop Guard** | SHA256-based tool call loop detection with circuit breaker. |
| 14 | **Session Repair** | 7-phase message history validation and automatic recovery from corruption. |
| 15 | **Path Traversal Prevention** | Canonicalization with symlink escape prevention. |
| 16 | **GCRA Rate Limiter** | Cost-aware token bucket rate limiting with per-IP tracking and stale cleanup. |

---

## 40 Channel Adapters

**Core:** Telegram, Discord, Slack, WhatsApp, Signal, Matrix, Email (IMAP/SMTP)  
**Enterprise:** Microsoft Teams, Mattermost, Google Chat, Webex, Feishu/Lark, Zulip  
**Social:** LINE, Viber, Facebook Messenger, Mastodon, Bluesky, Reddit, LinkedIn, Twitch  
**Community:** IRC, XMPP, Guilded, Revolt, Keybase, Discourse, Gitter  
**Privacy:** Threema, Nostr, Mumble, Nextcloud Talk, Rocket.Chat, Ntfy, Gotify  
**Workplace:** Pumble, Flock, Twist, DingTalk, Zalo, Webhooks

---

## 27 LLM Providers — 123+ Models

3 native drivers (Anthropic, Gemini, OpenAI-compatible) route to 27 providers:

Anthropic, Gemini, OpenAI, Groq, DeepSeek, OpenRouter, Together, Mistral, Fireworks, Cohere, Perplexity, xAI, AI21, Cerebras, SambaNova, HuggingFace, Replicate, Ollama, vLLM, LM Studio, Qwen, MiniMax, Zhipu, Moonshot, Qianfan, Bedrock, and more.

---

## OpenAI-Compatible API

Drop-in replacement for any tool that speaks the OpenAI API:

```bash
curl -X POST localhost:4200/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "researcher",
    "messages": [{"role": "user", "content": "Analyze Q4 market trends"}],
    "stream": true
  }'
```

---

## Migrate from OpenClaw

```bash
openraw migrate --from openclaw
openraw migrate --from openclaw --dry-run   # preview first
```

---

## Build from Source (GitHub)

When you clone the repo, you get everything — CLI, Desktop app, and all crates. One build produces both binaries:

```bash
git clone https://github.com/your-username/openraw
cd openraw
cargo build --release
```

**Output:**
- `target/release/openraw.exe` — CLI (TUI, commands, daemon)
- `target/release/openraw-desktop.exe` — Native desktop app (WebView2 window)

**First run:**
```bash
.\target\release\openraw.exe init    # configure API keys
.\target\release\openraw.exe start  # daemon, or run openraw-desktop.exe
# Dashboard → http://localhost:4200
```

**Requirements:** Rust, Visual Studio Build Tools (Windows), WebView2 for desktop app.

---

## Development

```bash
cargo build --release                # full build (CLI + desktop)
cargo build --workspace --lib        # libs only (faster iteration)
cargo test --workspace
cargo clippy --workspace --all-targets -- -D warnings
cargo fmt --all -- --check
.\scripts\build-and-test.ps1         # Windows: build + smoke test
```

---

## Stability

v0.1.0 is the first public release. Architecture is solid, test suite is comprehensive, security model is complete. That said:

- Breaking changes may occur between minor versions until v1.0
- Pin to a specific commit for production deployments
- [Open an issue](https://github.com/your-username/openraw/issues) if you find an edge case

---

## License

MIT — use it however you want.

---

<div align="center">

**Built with Rust. 16 security layers. Agents that actually work for you.**

</div>
