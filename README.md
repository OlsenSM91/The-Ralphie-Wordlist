# Ralphie Generator

A **streaming** wordlist generator that produces every possible combination of:

adjective + noun + 000..999

![Recording 2025-09-01 103106](https://github.com/user-attachments/assets/4be3c76e-747d-435b-8b7c-bd4ddb183841)

This tool takes two input files:

- `adjective_large.txt` — one adjective per line  
- `noun_large.txt` — one noun per line  

…and outputs each combination to **stdout** in real time, so you see results immediately as they are generated.

This project includes:

- **PowerShell version** (`ralphie-stream.ps1`) for Windows and PowerShell Core
- **POSIX Shell version** (`ralphie-stream.sh`) for Linux, macOS, BSD, and WSL

---

## 📜 Purpose

This tool is designed for:

- **Password pattern research** in controlled, authorized environments
- **Security entropy analysis** of weak keyspace constructions
- **Data generation** for lab experiments and simulations
- **Stress testing** parsers and pipelines with large, predictable datasets

⚠ **Ethical use only** — This generator must **only** be used in environments you own or have explicit, written permission to test. Never use against live systems, networks, or devices without authorization.

---

## 📂 File Structure

. ├── adjective_large.txt   # Input list of adjectives ├── noun_large.txt        # Input list of nouns ├── ralphie-stream.ps1    # PowerShell implementation └── ralphie-stream.sh     # Shell implementation

---

## ⚡ How It Works

Given:

- **A** = number of adjectives in `adjective_large.txt`
- **B** = number of nouns in `noun_large.txt`
- **R** = numeric range (`Start` to `End`, padded to 3 digits by default)

The total output size is:

Keyspace size = A × B × (R + 1)

Example:  
If A = 2,500, B = 5,000, Start = 0, End = 999:

Keyspace = 2,500 × 5,000 × 1,000 Keyspace = 12,500,000,000 combinations

Entropy:

H = log₂(Keyspace)

For the above example H ≈ 33.54 bits.

---

## 💻 PowerShell Usage

### Run with Defaults (000–999)
```powershell
.\ralphie-stream.ps1
```

Limit Range (example: 0–3)
```powershell
.\ralphie-stream.ps1 -Start 0 -End 3 | Select-Object -First 12
```

Save Output to File
```powershell
.\ralphie-stream.ps1 > ralphie.txt
```


---

🐚 Shell (sh/bash) Usage

Run with Defaults (000–999)
```bash
./ralphie-stream.sh
```

Limit Range (example: 0–3)
```bash
./ralphie-stream.sh adjective_large.txt noun_large.txt 0 3 | head -n 12
```

Save Output to File
```bash
./ralphie-stream.sh > ralphie.txt
```


---

🚀 Performance Notes

Streaming output means results appear as soon as they are generated.

Printing to a console is much slower than generating the list — redirect to a file for maximum speed.

Both scripts iterate in a triple nested loop: adjective → noun → number.

The implementation avoids extra buffering, so memory use is constant regardless of output size.



---

📊 Example Output

If adjective_large.txt contains:
```
quick
lazy
```
…and noun_large.txt contains:
```
fox
dog
```
Running with Start=0, End=3:
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

🔒 Responsible Disclosure Context

This common scheme (`adjective + noun + 3-digit number`) is **predictable** and has a limited keyspace.
When used for Wi-Fi or device defaults, it is susceptible to offline guessing once a handshake or equivalent capture is obtained.

Attached list sizes

`adjective_large.txt`: 17,910 lines

`noun_large.txt`: 55,238 lines


With a 3-digit suffix (000..999, 1,000 values):

K = 17,910 × 55,238 × 1,000 = 989,312,580,000 candidates
H = log₂(K) ≈ 39.85 bits


---

Crack-time estimates (WPA/WPA2, hashcat m=22000)

Hardware	Rate (candidates/s)	Avg time (50%)	Worst-case (100%)

RTX 4090	2,533,000	2d 06h 50m 00s	4d 13h 40m 00s
RTX 3080	839,300	7d 16h 34m 00s	15d 09h 08m 00s
Apple M3 Pro	186,000	34d 07h 50m 00s	68d 15h 40m 00s
Apple M1	48,500	131d 23h 00m 00s	263d 22h 00m 00s
4× RTX 4090	10,132,000	13h 43m 00s	1d 03h 26m 00s


> Avg time assumes the password is uniformly distributed; Worst-case is full exhaustion.



Observation: A single RTX 4090 averages ~2.3 days to crack this keyspace; a 4× GPU rig can do it in ~14 hours on average. This is not sufficient security.


---

If the vendor increases the suffix to 4 digits

Keyspace ×10

Entropy gain ≈ +3.32 bits

Still feasible for modern rigs in days, not years.



---

Remediation guidance

Replace fixed adjective + noun + 3-digits patterns with larger, uniformly random secrets or passphrases.

For Wi-Fi, prefer WPA3-SAE where supported.

If PSKs are unavoidable, use high-entropy random generation.

Avoid weak fallbacks like WPS or default vendor patterns.



---

🧪 Piping Ralphie into cracking tools

Ralphie writes to stdout, so it can be piped directly into tools like hashcat and John the Ripper.

Hashcat (GPU)

Linux/macOS:
```bash
./ralphie-stream.sh | hashcat -m 22000 -a 0 -w 4 -O target.22000 -
```

Windows PowerShell:
```
.\ralphie-stream.ps1 | & hashcat.exe -m 22000 -a 0 -w 4 -O .\target.22000 -
```

`-` at the end tells hashcat to read from stdin.

You can still apply rules:

```bash
./ralphie-stream.sh | hashcat -m 22000 -a 0 -r rules/best64.rule target.22000 -
```


---

John the Ripper (CPU/GPU)

Linux/macOS:
```bash
wpapcap2john capture.pcap > wifi.john
./ralphie-stream.sh | john --stdin --format=wpapsk wifi.john
```

Windows PowerShell:
```powershell
.\ralphie-stream.ps1 | & john.exe --stdin --format=wpapsk .\wifi.john
```

---

📎 References

Hashcat benchmarks for WPA/WPA2 PMKID/EAPOL (mode 22000)

Apple Silicon cracking performance reports

EFF Diceware Passphrase guidance (~77 bits for six words)

RFC 4086: Randomness Requirements for Security

John the Ripper stdin usage documentation



---

⚖ License

MIT License — use, modify, and distribute, provided all usage is legal and authorized.

---

🛡 Disclaimer

This software is provided “as is” without warranty. The authors are not responsible for misuse or legal consequences. Use only on systems you have permission to test.
