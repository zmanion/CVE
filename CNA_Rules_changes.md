# Changes to the CNA Operational Rules

##  Summary

In roughly the second half of 2023, the CNA Operational Rules were revised. This document highlights some of the (proposed) changes.

* Current [CVE Numbering Authority (CNA) Rules](https://www.cve.org/ResourcesSupport/AllResources/CNARules)
* Version 3.0 of the [CVE Numbering Authority (CNA) Rules](https://www.cve.org/Resources/Roles/Cnas/CNA_Rules_v3.0.pdf)
* Proposed revision?

## Highlights

### 1 "Governance" content moved to a separate document
The revised CNA Operational Rules are focused on administering and managing CNAs and assigning CVE IDs and publishing and maintaining CVE Records. The governance rules have been moved to (where?).

| Old | New |
| :--- | :--- |
| 3 Roots | governance doc |
| 4 CNA of Last Resort (CNA-LR) | governance doc? |
| more |  |

### 2 Program-wide content removed
Program-wide content has been removed from the document but remains on cve.org, examples include Appendix A: Definitions (integrated into cve.org [Glossary](https://www.cve.org/ResourcesSupport/Glossary)) and 1.2 CNA Program Structure (already on [cve.org](https://www.cve.org/ProgramOrganization/Structure)).

### 3 Reorganized sections

asdf

| Old | New |
| :--- | :--- |
| 8 CVE Record Requirements | 5 CVE Record Requirements |
| more | |

### 4 Introduction changed

Section 1 (Introduction) was edited significantly. CNA Program structure explanation and graphics moved/removed. Some text retained from the 'Old' document but re-organized.


### 5 Supplier and Product terms

Made "Supplier" the term for referring to any software or hardware creator, producer, vendor, distributor, etc. and "Product" the term for referring to any unit of software or hardware.

### 6 Physical attacks

(Section 4.1.8) Added further clarification on the appropriate CNA response for physical attacks or vulnerabilities via a physical vector: "CNAs MUST NOT assign CVE IDs for physical attacks unless there is a vulnerability in a specific security feature, claim, or policy that protects the system against physical attacks. For example, if a system deletes user data after a number of failed login attempts or only boots with known good components, and such protections can be reduced or bypassed by a vulnerability, then a CVE ID SHOULD be assigned. "

### 7 Malicious code

(Section 4.1.10) Added clarification that malicious code should not be assigned CVE: "CNAs SHOULD NOT assign CVE IDs for malicious code. This includes legitimate software that has been modified to become malicious, for example, "trojan horses” or similar supply chain compromises."
