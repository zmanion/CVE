# CVE Client Review October 2022
The following projects provide clients that are compatible with the new ([October 2022](https://cveproject.github.io/automation-transition)) [CVE Services](https://github.com/CVEProject/cve-services) 2.1 and [JSON 5.0](https://cveproject.github.io/cve-schema/schema/v5.0/docs/) format. Some of the projects provide additional capabilities and features.

## Vulnogram
Browser-hostable JavaScript application (also a more feature-rich Node.js server configuration, not evaluated), supports editing, submission.

Live: https://vulnogram.github.io/, use the [CVE 5.0 (beta)](https://vulnogram.github.io/cve5/) tab

Source: https://github.com/Vulnogram/Vulnogram

What code or branch does the live site use?

## cveClient
JavaScript library and simple HTML interface. JavaScript application, supports reservation(?), editing, submission.

Live: https://certcc.github.io/cveClient/

Source: https://github.com/CERTCC/cveClient

## cvelib
Python application, supports reservation, submission, user management.

Source: https://github.com/RedHatProductSecurity/cvelib

For Services 2.1 and JSON 5.0 testing as of September 2022, use the [cve-services-2.10](https://github.com/RedHatProductSecurity/cvelib/tree/cve-services-2.1.0) branch.

## CVE.js
JavaScript library (ECMAScript 6 requirement?), supports X, Y, not evaluated

Source: https://github.com/xdrr/cve.js

## Comparison
| Project | Language | License | Reservation | Editing | Submission | User managment |
| --- | --- | --- | --- | --- | --- | --- |
| Vulnogram | JavaScript, Node.js | MIT | No | Yes | Yes | No |
| cveClient | JavaScript | MIT-like? | Yes? | Yes | Yes | No? |
| cvelib | Python | MIT? | Yes | No | Yes | Yes |
| CVE.js | JavaScript (ECMAScript 6) | ? | Probably | No? | Probably | ? |
