# Analyze Domains Through Multiple Sources

Investigate suspicious domains and identify false positives by leveraging threat intelligence tools, including URLhaus, VirusTotal, and URLScan, to gather more context and respond faster.

## Usage

- Add your APIVoid, IP2Location, Urlscan and Virustotal API key to `flowpipe.pvars`
- Run the pipeline and specify ` domain``, e.g.,  `flowpipe pipeline run domains_review_through_multiple_sources --pipeline-arg 'domain=example.com'`
