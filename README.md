# Ralphie Generator

A **streaming** wordlist generator that produces every possible combination of:

```

adjective + noun + 000..999

```

![Recording 2025-09-01 103106](https://github.com/user-attachments/assets/4be3c76e-747d-435b-8b7c-bd4ddb183841)


This tool takes two input files:

- `adjective_large.txt` — one adjective per line
- `noun_large.txt` — one noun per line

…and outputs each combination to **stdout** in real-time, without buffering, so you see results immediately as they are generated.

This project includes:

- **PowerShell version** (`ralphie-stream.ps1`) for Windows and PowerShell Core
- **POSIX Shell version** (`ralphie-stream.sh`) for Linux, macOS, BSD, and WSL

---

## 📜 Purpose

This tool is designed for:

- **Password pattern research** and responsible disclosure reports
- **Security entropy analysis** of weak keyspace constructions
- **Data generation** for authorized lab experiments and simulations
- **Stress-testing** parsers and pipelines with large, predictable datasets

⚠ **Ethical use only** — This generator must **only** be used in environments you own or have explicit, written permission to test.  
Never use against live systems, networks, or devices without authorization.

---

## 📂 File Structure

```

.
├── adjective\_large.txt   # Input list of adjectives
├── noun\_large.txt        # Input list of nouns
├── ralphie-stream.ps1    # PowerShell implementation
└── ralphie-stream.sh     # Shell implementation

```

---

## ⚡ How It Works

Given:

- **A** = number of adjectives in `adjective_large.txt`
- **B** = number of nouns in `noun_large.txt`
- **R** = numeric range (`Start` to `End`, padded to 3 digits by default)

The total output size is:

```

Keyspace size = A × B × (R+1)

```

Example:  
If A = 2,500, B = 5,000, Start = 0, End = 999:

```

Keyspace = 2,500 × 5,000 × 1,000
Keyspace = 12,500,000,000 combinations

```

Entropy:

```

H = log₂(Keyspace)

````

For the above, H ≈ 33.54 bits — far too small to resist offline guessing at scale.

---

## 💻 PowerShell Usage

### Run with Defaults (000–999)
```powershell
.\ralphie-stream.ps1
````

### Limit Range (Example: 0–3)

```powershell
.\ralphie-stream.ps1 -Start 0 -End 3 | Select-Object -First 12
```

### Save Output to File

```powershell
.\ralphie-stream.ps1 > ralphie.txt
```

---

## 🐚 Shell (sh/bash) Usage

### Run with Defaults (000–999)

```bash
./ralphie-stream.sh
```

### Limit Range (Example: 0–3)

```bash
./ralphie-stream.sh adjective_large.txt noun_large.txt 0 3 | head -n 12
```

### Save Output to File

```bash
./ralphie-stream.sh > ralphie.txt
```

---

## 🚀 Performance Notes

* **Streaming output** means results appear as soon as they are generated.
* Printing to the console is **much slower** than generating the list — redirect to a file for maximum speed.
* Both scripts iterate in a triple nested loop: adjective → noun → number.
* There is no buffering in the final implementation, so memory use is constant regardless of output size.

---

## 📊 Example Output

If `adjective_large.txt` contains:

```
quick
lazy
```

…and `noun_large.txt` contains:

```
fox
dog
```

Running with `Start=0`, `End=3`:

```
quickfox000
quickfox001
quickfox002
quickfox003
quickdog000
quickdog001
quickdog002
quickdog003
lazyfox000
lazyfox001
lazyfox002
lazyfox003
lazydog000
lazydog001
lazydog002
lazydog003
```

---

## 🔒 Responsible Disclosure Context

This scheme (`adjective + noun + 3-digit number`) is **predictable** and has a **small keyspace**.
When used in password generation for Wi-Fi or devices, it is vulnerable to **offline guessing** once an authentication capture is obtained.

For responsible disclosure:

* Quantify `A`, `B`, and numeric range in the vendor's current implementation.
* Compute total keyspace and entropy.
* Compare against modern recommendations (≥60–80 bits of entropy).
* Provide concrete remediation steps:

  * Use longer numeric suffixes or more words
  * Enforce random selection from large lists
  * Support WPA3-SAE to mitigate offline attacks
  * Disable insecure fallback features like WPS

---

## ⚖ License

This tool is released under the MIT License.
You are free to use, modify, and distribute it, **provided all usage is legal and authorized**.

---

## 🛡 Disclaimer

This software is provided **"as-is"** without warranty of any kind.
The authors are **not responsible** for misuse, damage, or legal consequences resulting from unauthorized or malicious use.

Use responsibly and **only** on systems you have permission to test.
