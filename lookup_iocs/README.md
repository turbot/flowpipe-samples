# Analyze Lookup IOCs in Different Tools

Looks up submitted IOCs (Indicators of Compromise) in different applications and services, including AbuseIPDB, Hunter.io, VirusTotal, etc., and then returns selected results.

## Usage

- Add your APIVoid, IP2Location, Urlscan, Virustotal, AbuseIPDB, Hunter, Kickbox and HybridAnalysis API key to `flowpipe.pvars`
- Run the pipeline and specify `domain`, e.g., `flowpipe pipeline run lookup_iocs --pipeline-arg 'iocs=[{"id" : "1","type" : "ip","value" : "192.168.1.10"},{"id" : "2","type" : "domain","value" : "malicious-domain.com"}]'`
