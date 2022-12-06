CVE Services Tools
==================

The following is a list of clients, libraries, and other tools that work with CVE Services. These are primarily community-contributed and not developed, maintained or specifically endorsed by the CVE Project. This list is likely incomplete, feel free submit PRs or issues.

Here are Swagger docs for [prod](https://cveawg.mitre.org/api-docs/) and [test](https://cveawg-test.mitre.org/api-docs/).

# Table of Contents

* [CVE Services Clients](#cve-services-clients)
   * [Vulnogram](#vulnogram)
   * [cveClient](#cveclient)
   * [cvelib](#cvelib)
   * [CVE.js](#cvejs)
   * [Client Comparison](#client-comparison)
* [GitHub Integrations](#github-integrations)
   * [CVE CNA Bot](#cve-cna-bot)

<!-- Created by https://github.com/ekalinin/github-markdown-toc -->

# CVE Services Clients
See also [CVE_Services_clients](/CVE_Services_clients).

## Vulnogram
Browser-hostable JavaScript application (also a more feature-rich Node.js server configuration, not reviewed), supports user management, reservation, editing, submission. Vulnogram supports additional features such as generating a generic advisory.

Live: https://vulnogram.github.io/, use the [CVE 5.0 (beta)](https://vulnogram.github.io/cve5/) tab, uses 0.1.0-dev branch

Source: https://github.com/Vulnogram/Vulnogram

## cveClient
JavaScript library and simple HTML interface. JavaScript application, supports user managment, reservation, editing, submission.

Live: https://certcc.github.io/cveClient/

Source: https://github.com/CERTCC/cveClient

## cvelib
Python application, supports user management, reservation, submission, does not support edting, does not produce JSON.

Source: https://github.com/RedHatProductSecurity/cvelib

## CVE.js
JavaScript library (ECMAScript 6 requirement?), not reviewed.

Source: https://github.com/xdrr/cve.js

## Client Comparison
| Project | Language | License | User management | Reservation | Editing | Submission |
| --- | --- | --- | --- | --- | --- | --- |
| Vulnogram | JavaScript, Node.js | MIT | Yes | Yes | Yes | Yes |
| cveClient | JavaScript | MIT+CMU | Yes | Yes | Yes | Yes |
| cvelib | Python | MIT | Yes | Yes | No | Yes |
| CVE.js | JavaScript (ECMAScript 6?) | MIT | Yes | Yes | No | Yes |

# GitHub Integrations

## CVE CNA Bot
GitHub action that validates CVE JSON 5 and (optionally) submits to the CVE RSUS service.

Source: https://github.com/marketplace/actions/cve-cna-bot
