# Changes to the CNA Operational Rules

##  Summary

In roughly the second half of 2023, the CNA Operational Rules were revised. This document highlights some of the (proposed) changes.

* Current [CVE Numbering Authority (CNA) Rules](https://www.cve.org/ResourcesSupport/AllResources/CNARules)
* Version 3.0 of the [CVE Numbering Authority (CNA) Rules](https://www.cve.org/Resources/Roles/Cnas/CNA_Rules_v3.0.pdf)
* Proposed revision?

## Highlights

### 1 "Governance" content moved to a separate document
The revised CNA Operational Rules are focused on administering and managing CNAs and assigning CVE IDs and publishing and maintaining CVE Records. The governance rules have been moved to (where?). Formerly Sections 3, 5, and 6 ("Root CNAs," "Secretariat," and "Program Root CNA") have been removed from this document.

| Old | New |
| :--- | :--- |
| 3 Roots | governance doc |
| 4 CNA of Last Resort (CNA-LR) | governance doc? |
| more |  |

### 2 Program-wide content removed
Program-wide content has been removed from the document but remains on cve.org, examples include Appendix A: Definitions (integrated into cve.org [Glossary](https://www.cve.org/ResourcesSupport/Glossary)) and 1.2 CNA Program Structure (already on [cve.org](https://www.cve.org/ProgramOrganization/Structure)).

### 3 Reorganized sections

Many sections have been moved, reordered, moved to separate documents, or had their organizational hierarchies changed. This list is subject to change and will probably not reflect every alteration to the document. 

| Old | New |
| :--- | :--- |
| 8 CVE Entry Requirements | 5 CVE Record Requirements |
| 7 Assignment Rules | 4.2 CVE ID Assignment |
| 10 Defining a CNA's Scope | 3.1 Scope Definition |
| Appendix B Terms of Use | Separate [Terms of Use Page](https://www.cve.org/Legal/TermsOfUse) |
| 2 Sub-CNAs | 4 CNA Operational Rules |
| 11 CNA Rules Updates | 2 Changes to the CNA Operational Rules |


### 4 Introduction changed

Section 1 (Introduction) was edited significantly. CNA Program structure explanation and graphics moved/removed. Some text retained from the 'Old' document but re-organized.


### 5 Supplier and Product terms

Made "Supplier" the term for referring to any software or hardware creator, producer, vendor, distributor, etc. and "Product" the term for referring to any unit of software or hardware.

### 6 Physical attacks

(Section 4.1.8) Added further clarification on the appropriate CNA response for physical attacks or vulnerabilities via a physical vector: "CNAs MUST NOT assign CVE IDs for physical attacks unless there is a vulnerability in a specific security feature, claim, or policy that protects the system against physical attacks. For example, if a system deletes user data after a number of failed login attempts or only boots with known good components, and such protections can be reduced or bypassed by a vulnerability, then a CVE ID SHOULD be assigned. "

### 7 Malicious code

(Section 4.1.10) Added clarification that malicious code should not be assigned CVE: "CNAs SHOULD NOT assign CVE IDs for malicious code. This includes legitimate software that has been modified to become malicious, for example, "trojan horses” or similar supply chain compromises."

### 8 Section 2: Changes to the CNA Operational Rules

(Section 2) Expanded and moved a section explaining the process for changing or updating the CNA Operational Rules. Previously Section 11.

| Old | New |
| :--- | :--- |
| 11 CNA Rules Updates | 2 Changes to the CNA Operational Rules |

### 9 Section 1.2	Adherence to CVE Program Policies and Rules

(Section 1.2) Now contains clauses mandating that CNAs participating in the CVE Program adhere to the CVE Program rules, the CVE Terms of Use License, and the CNA Operational Rules.

### 10 "Sub-CNAs" Removed

Formerly Section 2, "Sub-CNAs" is no longer in use as a term. Under the new rules, all CVE Program participants who can assign CVE IDs are CNAs or CNAs of Last Resort (CNA-LR). The rules formerly described under "Sub-CNAs" are now under Section 4 CNA Operational Rules

### 11 Moved Definitions

Definitions are now in the [CVE Program Glossary](https://docs.google.com/document/d/1PV7DdToG8dWAubCR5sI73Cfdzkv_gk79oEvu-HJRqRQ/edit?usp=sharing). Formerly Appendix A. Note: CVE Record States are still under Appendix A.

| Old | New |
| :--- | :--- |
| Appendix A Definitions| [CVE Program Glossary](https://docs.google.com/document/d/1PV7DdToG8dWAubCR5sI73Cfdzkv_gk79oEvu-HJRqRQ/edit?usp=sharing), link in Section 1.4 |

### 12 Moved/Expanded Scope Definition

Moved and expanded guidance on defining CNA scope. Added guidance for EOL products, researchers & third-party coordinators, and for organizations performing multiple roles within the CVE Program.

| Old | New |
| :--- | :--- |
| 10 Defining a CNA’s Scope | 3.1 CNA Scope Definition |

### 13 Moved/Expanded CNA Administration

Further detailed rules and guidance for CNA Administration procedure, including Administration Interfaces, Points of Contact, and Coordinated Vulnerability Disclosure.

| Old | New |
| :--- | :--- |
| 2.4 Administration Rules | 3.2 CNA Administration |

### 14 "Root CNAs" Removed

Formerly Section 3 "Root CNAs" has been removed. The terms "Root CNAs," sband "Program Root CNA" are no longer in use. New terms are "Root" and "Top-Level Root" or "TL-Root."

### 15 Revised Vulnerability Determination and Assignment Rules, Including Cloud

Significant changes here, removed cloud assignment restrictions from CNA Operational Rules Sections 4.1, 4.2. Formerly Section 7.4.4, 7.4.5, and 7.4.6 contained language that restricted some CVE IDs from being assigned to cloud services; these sub-sections have been removed. Section 4.2.2 now contains the updated rules for "Primary Assignment." Added sub-section 4.2.2.4: "CNAs MUST NOT consider the type of technology (e.g., cloud, on-premises, hybrid, artificial intelligence, machine learning) as the sole basis for determining assignment."

New organization:
4.1 Vulnerability Determination (is it a vulnerability, or not, how many)
4.2 CVE ID Assignment (

| Old | New |
| :--- | :--- |
| 7.1 | 4.1 Vulnerability Determination |
| 7.2 | 4.1 Vulnerability Determination |
| 7.3 | 4.2 CVE ID Assignment |
| 7.4 | 4.2 CVE ID Assignment |
| 7.4.4,5,6 | 4.2.2 Primary Assignment |

### 16 EOL Rules Updated

Updated the end-of-life CVE Assignment/scope rules to be consistent with Section 3 of [End of Life Vulnerability Assignment Process](https://www.cve.org/Resources/General/End-of-Life-EOL-Assignment-Process.pdf). Section 3.1.11 in the CNA Operational Rules now provides appropriate guidance for defining CNA Scope with regard to EOL products. 

Also updated Section 4.2.2.12 in CNA Operational Rules to include reference to Section 5 of [End of Life Vulnerability Assignment Process](https://www.cve.org/Resources/General/End-of-Life-EOL-Assignment-Process.pdf), providing guidance on reporting vulnerabilities discovered in EOL products.
