# CVE Client Review October 2022
The following projects provide clients that are compatible with the new ([October 2022](https://cveproject.github.io/automation-transition)) [CVE Services](https://github.com/CVEProject/cve-services) 2.1 and [JSON 5.0](https://cveproject.github.io/cve-schema/schema/v5.0/docs/) format. Some of the projects provide additional capabilities and features.

## Vulnogram
Browser-hostable JavaScript application (also a more feature-rich Node.js server configuration, not reviewed), supports editing, submission, does not support user management or reservation. Vulnogram supports additional features such as generating a generic advisory.

Live: https://vulnogram.github.io/, use the [CVE 5.0 (beta)](https://vulnogram.github.io/cve5/) tab, uses 0.1.0-dev branch

Source: https://github.com/Vulnogram/Vulnogram

## cveClient
JavaScript library and simple HTML interface. JavaScript application, supports user managment, reservation, editing, submission.

Live: https://certcc.github.io/cveClient/

Source: https://github.com/CERTCC/cveClient

## cvelib
Python application, supports user management, reservation, submission, does not support edting, does not produce JSON.

Source: https://github.com/RedHatProductSecurity/cvelib

For Services 2.1 and JSON 5.0 testing as of September 2022, use the [cve-services-2.1.0](https://github.com/RedHatProductSecurity/cvelib/tree/cve-services-2.1.0) branch.

## CVE.js
JavaScript library (ECMAScript 6 requirement?), not reviewed.

Source: https://github.com/xdrr/cve.js

## Comparison
| Project | Language | License | User management | Reservation | Editing | Submission |
| --- | --- | --- | --- | --- | --- | --- |
| Vulnogram | JavaScript, Node.js | MIT | Yes | Yes | Yes | Yes |
| cveClient | JavaScript | MIT+CMU | Yes | Yes | Yes | Yes |
| cvelib | Python | MIT | Yes | Yes | No | Yes |
| CVE.js | JavaScript (ECMAScript 6?) | MIT | Yes | Yes | No | Yes |

Clients were not evaluated against the full API specification, use API version 2.1.0 or greater, here are Swagger docs for [prod](https://cveawg.mitre.org/api-docs/) and [test](https://cveawg-test.mitre.org/api-docs/).
