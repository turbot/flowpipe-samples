# IP Profile

A composite Flowpipe mod that aggregates data from AbuseIPDB, IP2Location and VirusTotal, offering in-depth and actionable intelligence on IP addresses."

## Usage

- Add your IP2Location, AbuseIPDB and VirusTotal API keys to `flowpipe.pvars`
- Run the pipeline and specify the IP address you want to scan, e.g., `flowpipe pipeline run ip_profiler --pipeline-arg ip_address='76.76.21.21'`
- Below is an example output.

```json
{
  "flowpipe": {
    "execution_id": "exec_cl1u2mocj6rlhum9igeg",
    "pipeline_execution_id": "pexec_cl1u2mocj6rlhum9igf0",
    "status": "finished"
  },
  "ip_profile": {
    "abuseipdb_abuse_reports": {
      "count": 5,
      "lastPage": 1,
      "nextPageUrl": null,
      "page": 1,
      "perPage": 25,
      "previousPageUrl": null,
      "results": [
        {
          "categories": [15],
          "comment": "(PERMBLOCK) 76.76.21.21 (US/United States/-) has had more than 4 temp blocks",
          "reportedAt": "2023-10-21T05:10:34+00:00",
          "reporterCountryCode": "LT",
          "reporterCountryName": "Lithuania",
          "reporterId": 84727
        },
        {
          "categories": [4],
          "comment": "(CT) IP 76.76.21.21 (US/United States/-) found to have 568 connections",
          "reportedAt": "2023-10-21T04:40:28+00:00",
          "reporterCountryCode": "LT",
          "reporterCountryName": "Lithuania",
          "reporterId": 84727
        },
        {
          "categories": [4],
          "comment": "(CT) IP 76.76.21.21 (US/United States/-) found to have 610 connections",
          "reportedAt": "2023-10-21T04:10:17+00:00",
          "reporterCountryCode": "LT",
          "reporterCountryName": "Lithuania",
          "reporterId": 84727
        },
        {
          "categories": [4],
          "comment": "(CT) IP 76.76.21.21 (US/United States/-) found to have 584 connections",
          "reportedAt": "2023-10-21T03:40:13+00:00",
          "reporterCountryCode": "LT",
          "reporterCountryName": "Lithuania",
          "reporterId": 84727
        },
        {
          "categories": [4],
          "comment": "(CT) IP 76.76.21.21 (US/United States/-) found to have 504 connections",
          "reportedAt": "2023-10-21T03:10:08+00:00",
          "reporterCountryCode": "LT",
          "reporterCountryName": "Lithuania",
          "reporterId": 84727
        }
      ],
      "total": 5
    },
    "abuseipdb_ip_info": {
      "abuseConfidenceScore": 11,
      "countryCode": "US",
      "domain": "vercel.com",
      "hostnames": null,
      "ipAddress": "76.76.21.21",
      "ipVersion": 4,
      "isPublic": true,
      "isTor": false,
      "isWhitelisted": false,
      "isp": "Vercel Inc",
      "lastReportedAt": "2023-10-21T05:10:34+00:00",
      "numDistinctUsers": 1,
      "totalReports": 5,
      "usageType": "Content Delivery Network"
    },
    "ip2location_ip_location": {
      "as": "Amazon.com Inc.",
      "asn": "16509",
      "city_name": "Walnut",
      "country_code": "US",
      "country_name": "United States of America",
      "ip": "76.76.21.21",
      "is_proxy": false,
      "latitude": 34.0154,
      "longitude": -117.858225,
      "region_name": "California",
      "time_zone": "-07:00",
      "zip_code": "91789"
    },
    "virustotal_ip_scan": {
      "last_analysis_stats": {
        "harmless": 66,
        "malicious": 1,
        "suspicious": 0,
        "timeout": 0,
        "undetected": 22
      },
      "total_votes": {
        "harmless": 3,
        "malicious": 2
      }
    }
  }
}
```
