# IPsec & IoT
#### Daniel Migault

---
# IoT Security

There is no ONE IoT main use case:
* Wide range of environements car, home, outdoor
* Wide range of devices type devices
* Wide range of ways of management: application, devices,...

IPsec can be used to secure your IoT environement:
* This is NOT the only way to secure your IoT environment
* How to secure your IoT environement is not always trivial
---
# IoT Security - Security Protocols

At least the following security protocols should be considered:
* Constrained Object Security (COSE), JSON Object Security (JOSE), DNSSEC, S-MIME, CMS...
  * Secures Application Data (Web Objects...)
* Object Security for Constrained RESTful Environments (OSCORE)
  * Secures Web Object communications (HTTP) 
  * Secures HTTP signaling while enabling HTTP-CoAP proxies 
* Datagram Transport Layer Security (D)TLS
  * Secures an application commmunications (Session)
* IP Security (IPsec)
  * Secures device communications (IP)

---
# IoT Security Protocols

<font size="4">

```
+-----------------------------------+
|        Application Data           |
+-----------------------------------+
+-----------------------------------+
|           JOSE / COSE             |
+-----------------------------------+
+-----------------------------------+  \
|      Application Signaling        |  |
|  Requests / Responses / Signaling |  |
|-----------------------------------|  |
|               OSCORE              |  | CoAP / HTTP
|-----------------------------------|  |
| Messaging Layer / Message Framing |  |
+-----------------------------------+  /
+-----------------------------------+
|              (D)TLS               |
+-----------------------------------+
+-----------------------------------+
|          UDP / TCP / ...          |
+-----------------------------------+
+-----------------------------------+
|              IPsec                |
+-----------------------------------+
+-----------------------------------+
|               IP                  |
+-----------------------------------+
```
</font>

---
# IoT Security Protocols

The choice of the appropriated layer depends among others:
* The nature of application or service
* The type of communications distributed vs centralized
* The relation with infrastructure
* ...

---
# IoT Security Protocols - Application Data

Application Data Security characteristics:
* Asserts the ownership of the data. 
* Uses asssymetric cryptography to encrypt or authenticate 
  * Public Key limits the reverse operation to the Private key
    * Usefull for confidentiality
  * Private Key open the reverse operation to the Public Key
    * Usefull for proof of origin 
* Enables caching as provenance of the content does not matter 

---
# IoT Security Protocols - Application Data

Example:
* DNS(EC)
  * Origin-to-many security 	 
  * Data is cached in all resolvers
  * Signed with the Private Key of the data onwer
  * Validated by DNS resolvers with the Public Key 
  * A global chain of trust enables vaidation of the data.
* Emails SMIME:
  * End-to-end security
  * Can be delayed, take various transport mode. 
  * Encrypted with the destination Public Key (Confidentiality)
  * Signed with the sender Private Key (Proof of origin)
---

# IoT Security Protocols - OSCORE

OSCORE extends the Application Data Security to communications
* RESTful Communication includes some HTTP signaling 
* while other HTTP signaling is left to the session management.  

Non protected part of HTTP signaling is necessary to enable:
* HTTP-to-CoAP and CoAP-to-HTTP translation
* Interconnection between CoAP and HTTP world 
---

# IoT Security Protocols - OSCORE

OSCORE characteristics:
* Application-to-Service communication security
  * Motes identifiers handled by the application 
  * Independent of the infrastructure
* Secures exchanges over the path provided by the infrastructure
  * **Between Application Data and Transport Security**
* Usually relies on symetric cryptography with shared keys:
  * Used to authenticate and encrypt the exchanges
  * No proof of origin 
---

# IoT Security Protocols - (D)TLS 

Transport Security (D)TLS characteristcis:
* Application-to-Service communication security
  * Motes identifiers handled by the application 
  * Independent of the infrastructure
* User-to-Service communication security
  * (D)TLS autenticates the communication to the service
  * User authentication is performed by the service
  * User (D)TLS termination point is usually not considered

---

# IoT Security Protocols - (D)TLS

(D)TLS characteristics:
* Application-to-Service communication security
  * Motes identifiers handled by the application 
  * Independent of the infrastructure
* Secures exchanges over the path provided by the infrastructure
  * **Secures Application session (HTTP) above UDP/TCP**
* Usually relies on symetric cryptography with shared keys:
  * Used to authenticate and encrypt the exchanges
  * No proof of origin 
---

# IoT Protocols - IPsec

IPsec characteristics:
* Secure IP communications:
  * Extends a security domain
  * Secures VPN Client path to a Security Gateway
  * End-to-end Security between IP addresses

* Protects the infrastructure:
  * Tunnel, End-to-end
  * Unicast, multicast
  * Flexible alternate authentication credential management
    * IPsec protects communications agreed without IKEv2


---

# IoT Security Protocols 

(D)TLS/OSCORE is envisioned for communications:
* Between applications (application session)
* Between user/application and services 
* Relying on HTTP
* With a Key Exchange negotiation for each communication

---

# IoT Security - Security Protocols 

IPsec is envisioned for communications:
* Within a specific security domain ( like your home network)
* Between (many) devices belonging to that domain
  * Configured by a same admin
  * Provisionned with a specific control plan $\neq$ IKEv2 
* Involving constrainted battery powered devices
  * ESP Header Compression (EHC) reduces payload overhead
* Long term sessionless communications

---

# Use Cases - Mote

A mote with unidirectional communication to a local destination:
* Periodically sending information (temperature, door status) 
* Receiving a simple signal (open the door)

IP/ESP/Data provides smaller payload over IP/UDP/DTLS/{HTTP, CoAP/OSCORE}

<img src="https://github.com/mglt/lecture-ipsec-iot/blob/master/fig/use_case_e2e-unidirectional.png" height="200">

---


# Use Cases - Mote

Basic interactions and birectional communication may include:  
* Communication using a control channel - eventually multicast 
* Basic device-to-device communications (Ping - like) 

<img src="https://github.com/mglt/lecture-ipsec-iot/blob/master/fig/use_case_e2e-bidirectional.png" height="200">

---

# Use Cases - IPsec for Motes

In this case, the main drivers for chosing IPsec could be:
* Communications 
  * with a specific mote (IP) 
  * within a specific domain
  * Long term sessions
* Device
  * Limited or simple interactions ($\neq$ RESTful application)
  * Very constrainted 
    * Minimize the payload size
    * Support alternate KEX or key provisionning
* Management
  * mutlicast
  * Alternate key provisioning, KEX

---

# Use Cases - IPsec for Motes

IPsec secures IP communicatiosn between Identities:
* SPI ( not IP addresses) identifies the communication
* SPI is at the IP layer

The other end point needs acces the SPI (IP layer):
* Does not fit communications between mote and Cloud

Note: IPv6 provides lots of IP addresses

---


# Use Cases - Security Domain

<img src="https://github.com/mglt/lecture-ipsec-iot/blob/master/fig/secure-domain-architecture-ipsec.svg" height="500">


---
# Use Cases - Security Domain

The Security Domain is defined by the Home Network:
* Motes provide data to a Controller / Aggrehator using IPsec
 * Mote origin is important
* Health Care sensors extends the Security Domain 

Controller / Aggregators:
* May process the traffic or not.
* May forward the mote packet to the Cloud
  * IPsec: Virtualized network shadowing the home network
* May process data and send them to a service
  * HTTPS: service

---
# Use Cases - Security Domain

Aggregators, controllers present the following adavantages:
* Provides more control on the data exchanged with the Cloud
* Enable to change Service, Cloud provider
* Provides additional privacy 
  * Prevents direct communication with service

---
# ESP Header Compression (EHC)

Energy cost of IoT communication 
* Increase with the number of radio frames exchanged
* Full / empty radio frame have the same cost


Security protocol overhead may be larger than a radio frame

---
# EHC - Ex AES-CCM 8 bytes IV

Security protocol overhead (bytes) 


| DTLS |  ESP |   EHC  |
-------|------|----------
| 29   | 20   | 8 - 20 |  

Radio Frame size (bytes)

| 802.15.4 |  LORA | Bluetooth |SIGFOX |
-----------|-------|-----------|--------
| 102      | > 59  | >23       |  12   |

Note AES-GCM_16 has a 16 byte IV instead of 8 bytes

---
# EHC - Goals


HEC is a tool box that reduces ESP networking overhead:
* Compression depends on the context
* Focused on IoT but extended to the standard VPN use case.

This presentation illustrates how to compress ESP packets:
* IPv6 ESP VPN protecting an IPv6 UDP communication
* Can be extended to any other use case

Compression is achieved:
* Using specific cryptographic algorithms (implicit IV)
* HEC
* IPv6 Header Compression (Outside EHC)



---
# ESP Packet - Example

Standard IPv6 VPN ESP packet (AES-CCM 8 bytes IV):
<font size="2">

```
       0                   1                   2                   3
       0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
   -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+---
   E|               Security Parameters Index (SPI)                 |  ^
   S+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+  |
   P|                      Sequence Number (SN)                     |  |
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+  |
    |                                                               |  |
    |                             IV                                |  |
   -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- |
   I|version| traffic class |               flow label              |^ |
   P+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+| |
   v|         payload length        |  next header  |   hop limit   || |
   6+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+| |
    |                                                               || a
    |                      inner source IP                          || u
    |                                                               |e t
    |                                                               |n h
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+c e
    |                                                               |r n
    |                    inner destination IP                       |y t
    |                                                               |p i
    |                                                               |t c
   -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+e a
   U|          source port          |           dest port           |d t
   D+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+| e
   P|             length            |            checksum           || d
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+| |
    |                                                               || |
    ~                        APPLICATION DATA                       ~| |
    |                                                               || |
   -|                                               +-+-+-+-+-+-+-+-+| |
   E|                                               |    Padding    || |
   S+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+| |
   P|     Padding (continue)        |  Pad Length   | Next Header   |v v
   -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+---
    |         Integrity Check Value-ICV   (variable)                |
    |                                                               |
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```
</font>

---
# ESP Packet - Example

IPv6 ESP VPN protecting an IPv6 UDP communication
* ipsec_mode is set to "Tunnel"
* Inner packet is IPv6 / UDP
* Inner IPv6 ( UDP port) value may:
  * Be the specific negotiated SA Selectors
  * Belong to a Range of engotiated SA Selectors 

---
# Implicit IV

AES-CCM, AES-GCM and Chacha20Poly1305 requires a 8 byte long IV that never repeats.

Sequence Number (SN) are 4 byte long and never repeats. 
* Extended SN are 8 byte long

ENCR_AES_CCM_8_IIV, ENCR_AES_GCM_16_IIV and ENCR_CHACHA20_POLY_IIV:
* Generates the IV from the SN

---
# Implicit IV

Implicit IV with a 4 byte Sequence Number

<font size="5">

```
0                   1                   2                   3
0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                              Zero                             |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                      Sequence Number                          |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```
</font>

Implicit IV with an 8 byte Extended Sequence Number

<font size="5">

```

0                   1                   2                   3
0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                         Extended                              |
|                      Sequence Number                          |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```
</font>

---
# Implicit IV - ESP Packet Example

Implicit IV achieves a compression of:
* 8 bytes over ENCR_AES_CCM_8
* 16 bytes over ENCR_AES_CCM_16

<font size="2">

```
       0                   1                   2                   3
       0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
   -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+---
   E|               Security Parameters Index (SPI)                 |  ^
   S+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+  |
   P|                      Sequence Number (SN)                     |  |
   -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- |
   I|version| traffic class |               flow label              |^ |
   P+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+| |
   v|         payload length        |  next header  |   hop limit   || |
   6+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+| |
    |                                                               || a
    |                      inner source IP                          || u
    |                                                               |e t
    |                                                               |n h
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+c e
    |                                                               |r n
    |                    inner destination IP                       |y t
    |                                                               |p i
    |                                                               |t c
   -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+e a
   U|          source port          |           dest port           |d t
   D+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+| e
   P|             length            |            checksum           || d
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+| |
    |                                                               || |
    ~                        APPLICATION DATA                       ~| |
    |                                                               || |
   -|                                               +-+-+-+-+-+-+-+-+| |
   E|                                               |    Padding    || |
   S+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+| |
   P|     Padding (continue)        |  Pad Length   | Next Header   |v v
   -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+---
    |         Integrity Check Value-ICV   (variable)                |
    |                                                               |
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```
</font>

---
# ESP Header Compression (EHC)

EHC provides a framework to compress ESP protected payloads:
* To increase the life time of battery powered devices
* To enable IPsec interoperability with constrained devices 

EHC takes advantage of the SA agreement (configuration) to:
* Prevent repeating fields already defined by the SA
* Agree on ESP and inne rpacket compression rules
* Prevent any compression signalling within the ESP packet.

---
# EHC - Architecture


<font size="5">

```
              EHC Strategy,                       EHC Strategy,
              EHC Context    <==================> EHC Context
                   |                                    |
      EHC Rules    |                          EHC Rules |
           |       |                           |        |
           v       v                           v        v
          +====================+              +====================+
          |        ESP         |              |         ESP        |
          +====================+              +====================+
          | < pre-esp >        |              | < pre-esp >        |
          +--------------------+              +--------------------+
          | < clear text esp > |              | < clear text esp > |
          +--------------------+              +--------------------+
          | < encryption >     |              | < encryption >     |
          +--------------------+              +--------------------+
          | < post-esp >       |              | < post-esp >       |
          +--------------------+              +--------------------+
```
</font>

---
# EHC - Architecture

*EHC Rules* (de)compresses fields during ESP processing:
* pre-esp: inner packet (de)compression (before ESP)
* clear-text esp: non encrypted ESP packet (de)compression
* post-esp: encrypted ESP packet (de)compression

*EHC Context* provides parameters necessary for the EHC Rules

*EHC Strategy* defines the coordination of EHC Rules
* Derivation of EHC Context parameters (SA or not)
* Choice and order of EHC Rules 


---
# EHC - Architecture


EHC takes advantage of an explicit negotiation (IKEv2)
* EHC Strategy
* EHC Context

EHC Context and EHC Strategy :
* Defines EHC Rules that are activated
* Provides the sufficient parameters to (de)compress

EHC does not rely on 
* In-band signalling of the compression
* Learning, discovery phases - ROHC


---
# EHC - EHC Rules

<font size=5>
  
```
+---------------+-------+---------+----------------+
|   EHC Rule    | Field | Action  |  Parameters    |
+---------------+-------+---------+----------------+
|               | f1    |    a1   | p1_1, ... p1_n |
|               +-------+---------+----------------+
| EHC_RULE_NAME ~      ...                         ~
|               +-------+---------+----------------+
|               | fm    |    am   | pm_1, ... pm_n |
+---------------+-------+---------+----------------+
```
</font>

* EHC_RULE_NAME designates the name of the EHC Rule
* Field designates the field to be compressed
* Action: how (de)compression is performed
* Parameters: necessary arguments to perform the action
  * Provided by the EHC Context

---
# EHC - EHC Rules

(De)compression actions are one of the following actions:
<font size=5>
  
```
+-----------------+-----------------+----------------------+
| Function        | Compression     | Decompression        |
+-----------------+-----------------+----------------------+
| send-value      | No              | No                   |
| elided          | Not send        | Get from EHC Context |
| lsb(_lsb_size)  | Sent LSB        | Get from EHC Context |
| lower           | Not send        | Get from lower layer |
| checksum        | Not send        | Compute checksum.    |
| padding(_align) | Compute padding | Get padding          |
+-----------------+-----------------+----------------------+
```
</font>

---
# EHC - EHC Rules

EHC Rules compress:
* The Inner IPv6 Packet fields
* The ESP fields

There is no one-to-one mapping between EHC_RULE and fields
* One EHC_RULE may compress multiple fields
* One field may be addressed by multiple EHC_RULES
  * Selection is performed by the EHC Strategy
  
---
# EHC - EHC Context

For each field EHC Context provides:
* The value of the field - for example negotiated out-of-band
* An indication 
  * Where the value may be derived from
  * How the value may be derived from 

In most cases, the value has already been agreed with IKEv2
* part of the SA

---
# EHC - Inner IPv6 Packet Example

<font size="5">

```
  0                   1                   2                   3
  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- 
I|version| traffic class |               flow label              |
P+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
v|         payload length        |  next header  |   hop limit   |
6+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |                                                               |
 |                      inner source IP                          |
 |                                                               |
 |                                                               |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |                                                               |
 |                    inner destination IP                       |
 |                                                               |
 |                                                               |
-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
U|          source port          |           dest port           |
D+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
P|             length            |            checksum           |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |                                                               |
 ~                        APPLICATION DATA                       ~
 |                                                               |
 |                                               +-+-+-+-+-+-+-+-+
 |                                               |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

```
</font>


---
# EHC - Inner IPv6 Packet

Inner IPv6 packet commpression:
* IPv6 compression only occurs with IPsec Tunnel mode
* Occurs in the pre esp phase

Compression of the Inner IPv6 packet is performed in two phases:
* Inner IPv6 header compression
* Inner transport compression


---
# EHC - Inner IPv6 Header - EHC Context

EHC Context provides the following IPv6 header information:

| Context Attribute | In SA | Possible Values              |
--------------------|-------|-------------------------------
| ip_version        | Yes   | "IPv4", "IPv6"               |
| ip6_tcfl_comp     | No    | "Outer",  "Value", "UnComp"  |
| ip6_tc            | No    | IPv6 Traffic Class           |
| ip6_fl            | No    | IPv6 Flow Label              |
| ip6_hl_comp       | No    | "Outer",  "Value", "UnComp"  |
| ip6_hl            | No    | Hop Limit Value              |
| ip6_src           | Yes   | IPv6 Source Address          |
| ip6_dst           | Yes   | IPv6 Destination Address     |


---
# EHC - Inner IPv6 Header - EHC Rules

EHC_RULES defines inner IPv6 header (de)compression:


| EHC Rule     | Field          | Action | Parameters |
---------------|----------------|--------|------------|
| IP6_OUTER    | Version        | elided | ip_version |
|              | Traffic Class  | lower  |            |
|              | Flow Label     | lower  |            |
| IP6_VALUE    | Version        | elided | ip_version |
|              | Traffic Class  | elided | ip6_tc     |
|              | Flow Label     | elided | ip6_fl     |


---
# EHC - Inner IPv6 Header - EHC Rules

| EHC Rule     | Field          | Action | Parameters |
---------------|----------------|--------|------------|
| IP6_LENGTH   | Payload Length | lower  |            |
| IP6_NH       | Next Header    | elided | l4_proto   |
| IP6_HL_OUTER | Hop Limit      | lower  |            |
| IP6_HL_VALUE | Hop Limit      | elided | ip6_hl     |
| IP6_SRC      | Source Address | elided | ip6_src    |
| IP6_DST      | Dest. Address  | elided | ip6_dst    |


---
# EHC - Inner UDP - EHC Context

EHC Context provides the following UDP information:

| Context Attribute | In SA | Possible Values                    |
--------------------|-------|--------------------
| l4_proto          | Yes   | IPv6/ESP Next Header,IPv4 Protocol |
| l4_src            | Yes   | UDP/UDP-Lite/TCP Source Port       |
| l4_dst            | Yes   | UDP/UDP-Lite/TCP Destination Port  |



---
# EHC - Inner UDP - EHC Rules

EHC_RULES defines inner UDP (de)compression:

| EHC Rule   | Field        | Action   | Parameters |
-------------|--------------|----------|-------------
| UDP_SRC    | Source Port  | elided   | l4_source  |
| UDP_DST    | Dest. Port   | elided   | l4_dest    |
| UDP_LENGTH | Length       | lower    |            |
| UDP_CHECK  | UDP Checksum | checksum |            |


---
# EHC - ESP 

Standard IPv6 VPN ESP packet:
<font size="5">

```
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|               Security Parameters Index (SPI)                 |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                      Sequence Number (SN)                     |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                                                               ~ 
~                      Inner Packet             +-+-+-+-+-+-+-+-+
|                                               |    Padding    |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|     Padding (continue)        |  Pad Length   | Next Header   |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|         Integrity Check Value-ICV   (variable)                |
|                                                               |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```
</font>


---
# EHC - ESP - EHC Context

EHC Context provides the following ESP information:

| Context Attribute | In SA | Possible Values          |
--------------------|-------|--------------------------|
| ipsec_mode        | Yes   | "Tunnel", "Transport"    |
| outer_version     | Yes   | "IPv4", "IPv6"           |
| esp_spi           | Yes   | ESP SPI                  |
| esp_spi_lsb       | No    | 0, 1, 2, 3, 4            |
| esp_sn            | Yes   | ESP Sequence Number      |
| esp_sn_lsb        | No    | 0, 1, 2, 3, 4            |
| esp_sn_gen        | No    | "Time", "Incremental"    |
| esp_align         | No    | 8, 16, 24, 32            |
| esp_encr          | Yes   | ESP Encryption Algorithm |


---
# EHC - ESP - EHC Rules

EHC_RULES defines inner ESP (de)compression:


| EHC Rule| Field             | Action  | Parameters                |
----------|-------------------|---------|----------------------------
| ESP_SPI | SPI               | lsb     | esp_spi_lsb, esp_spi      |
| ESP_SN  | Seq. Number       | lsb     | esp_sn_lsb, esp_sn_gen,   |
|         |                   |         | esp_sn                    |
| ESP_NH  | Next Header       | elided  | l4_proto, ipsec_mode      |
| ESP_PAD | Pad Length,       | padding | esp_align, esp_encr       |
|         | Padding           |         |                           |


---
# EHC Strategy: Diet-ESP

EHC Strategy defines the orchestration of the EHC Rules
* EHC_RULES are not agreed individually between the peers 
* EHC Strategies are standardized
* EHC Strategies are described with EHC Rules but can be implemented differently 


This presentation defines the EHC Strategy named: Diet-ESP

Diet-ESP results results from a compromise between:
* Compression efficiency,
* Ease to configure Diet-ESP (EHC Context)
* Various use cases (IoT, standard VPN)

---
# EHC Strategy: Diet-ESP

* Ease to configure:
  * Selcting "OUTER" EHC Rules  
  * Most commonly used parameters.
    * esp_sn_gen is set to "Incremental"
* Use cases vs Compression efficiency:
  * IPv4 compression has been limited in favor of IPv6 (IoT)    
* Diet-ESP defines a logic to set the necessary parameters from SA
  * limits the setting of parameters.

---
# EHC Strategy: Diet-ESP

If Diet-ESP is agreed (in SA):
* ESP EHC Rule set is activated
If ip_version == 4 (in SA):
* IPv4 EHC Rule set is activated
If ip_version == 6 (in SA):
* IPv6 EHC Rule set is activated
If l4_proto == UDP (SA):
* UDP EHC Rule set activated
If l4_proto == TCP (SA):
* TCP EHC Rule set is activated


---
# EHC Strategy: Diet-ESP
                                
ESP:

| EHC Rule | Activated if | Parameter   | Value      |
-----------|--------------|-------------|-------------
| ESP_SPI  | Diet-ESP     | esp_spi_lsb | Negotiated |
|          |              | esp_spi     | In SA      |
| ESP_SN   | Diet-ESP     | esp_sn_lsb  | Negotiated |
|          |              | esp_sn_gen  | Negotiated |
|          |              | esp_sn      | In SA      |
| ESP_NH   | Diet-ESP     | ipsec_mode  | In SA      |
|          |              | l4_proto    | In SA      |
| ESP_PAD  | Diet-ESP     | esp_align   | Negotiated |
|          |              | esp_encr    | In SA      |



---
# EHC Strategy: Diet-ESP


IPv6:

| EHC Rule     | Activated if  | Parameter  | Value |
---------------|---------------|------------|--------
| IP6_OUTER    | ip_version==6 | ip_version | In SA |
| IP6_LENGTH   | ip_version==6 | None       |       |
| IP6_NH       | ip_version==6 | l4_proto   | In SA |
| IP6_HL_OUTER | ip_version==6 | None       |       |
| IP6_SRC      | ip_version==6 | ip6_src    | In SA |
| IP6_DST      | ip_version==6 | ip6_dst    | In SA |

---
# EHC Strategy: Diet-ESP 

UDP

| EHC Rule   | Activated if | Parameter | Value |
-------------|--------------|-----------|--------
| UDP_SRC    | l4_proto==17 | l4_source | In SA |
| UDP_DST    | l4_proto==17 | l4_dest   | In SA |
| UDP_LENGTH | l4_proto==17 | None      |       |
| UDP_CHECK  | l4_proto==17 | None      |       |


---
# EHC Strategy: Diet-ESP 


Parameters that the two peers needs to agree on are:

 * esp_sn_lsb
 * esp_spi_lsb
 * esp_align
 * udplite_coverage
 * tcp_lsb
 * tcp_options
 * tcp_urgent


---
# EHC Strategy: Diet-ESP - Single UDP Session IoT VPN



 * esp_sn_lsb: 0
 * esp_spi_lsb: 0
 * esp_align: 8

Diet-ESP results in a reduction of 61 bytes overhead.  
Implicit_IV results in a 8 byte compression (ENCR_AES_CCM_8_IIV)

---
# EHC Strategy: Diet-ESP - Single UDP Session IoT VPN

<font size="2">

```
     0                   1                   2                   3
     0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
   -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+---
   E|               Security Parameters Index (SPI)                 |  ^
   S+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+  |
   P|                      Sequence Number (SN)                     |  |
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+  |
    |                                                               |  |
    |                             IV                                |  |
   -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- |
   I|version| traffic class |               flow label              |^ |
   P+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+| |
   v|         payload length        |  next header  |   hop limit   || |
   6+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+| |
    |                                                               || a
    |                      inner source IP                          || u
    |                                                               |e t
    |                                                               |n h
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+c e
    |                                                               |r n
    |                    inner destination IP                       |y t
    |                                                               |p i
    |                                                               |t c
   -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+e a
   U|          source port          |           dest port           |d t
   D+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+| e
   P|             length            |            checksum           || d
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+| |
    |                                                               || |
    ~                        APPLICATION DATA                       ~| |
    |                                                               || |
   -|                                               +-+-+-+-+-+-+-+-+| |
   E|                                               |    Padding    || |
   S+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+| |
   P|     Padding (continue)        |  Pad Length   | Next Header   |v v
   -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+---
    |         Integrity Check Value-ICV   (variable)                |
    |                                                               |
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```
</font>

---
# EHC Strategy: Diet-ESP - Single UDP Session IoT VPN

<font size="5">

```
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+ ^
|                                                               | aut
~                        APPLICATION DATA                       ~ hen
|                          (encrypted)                          | tic
|                                               +-+-+-+-+-+-+-+-+ ate
|                                               |               | V
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+               |--
|         Integrity Check Value-ICV   (variable)                |
|                                               +-+-+-+-+-+-+-+-+
|                                               |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

```
</font>


---
# EHC Strategy: Diet-ESP - Traditional VPN


 * esp_sn_lsb: 2
 * esp_spi_lsb: 2
 * esp_align: 8

Diet-ESP results in a reduction  of 32 bytes.
Implicit_IV results in a 8 byte compression (ENCR_AES_CCM_8_IIV)

---
# EHC Strategy: Diet-ESP - Traditional VPN

Standard ESP VPN Packet Description

<font size="2">

```
     0                   1                   2                   3
     0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
   -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+---
   E|               Security Parameters Index (SPI)                 |  ^
   S+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+  |
   P|                      Sequence Number (SN)                     |  |
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+  |
    |                                                               |  |
    |                             IV                                |  |
   -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- |
   I|version| traffic class |               flow label              |^ |
   P+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+| |
   v|         payload length        |  next header  |   hop limit   || |
   6+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+| |
    |                                                               || a
    |                      inner source IP                          || u
    |                                                               |e t
    |                                                               |n h
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+c e
    |                                                               |r n
    |                    inner destination IP                       |y t
    |                                                               |p i
    |                                                               |t c
   -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+e a
   T|          source port          |           dest port           |d t
   C+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+| e
   P|                      Sequence Number (SN)                     || d
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+| |
    |                     ACK Sequence Number                       || |
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+| |
    |Off. | Rserv |      Flags      |         Window Size           || |
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+| |
    |             Checksum          |      Urgent Pointer           || |
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+| |
    |                                                               || |
    ~                        APPLICATION DATA                       ~| |
    |                                                               || |
   -|                                               +-+-+-+-+-+-+-+-+| |
   E|                                               |    Padding    || |
   S+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+| |
   P|     Padding (continue)        |  Pad Length   | Next Header   |V V
   -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+---
    |         Integrity Check Value-ICV   (variable)                |
    |                                                               |
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```
</font>



---
# EHC Strategy: Diet-ESP - Traditional VPN

Diet-ESP VPN Packet Description


<font size="2">

```
    0                   1                   2                   3
    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+---
   |             SPI               |              SN               |  ^
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+--|
   |  Next Header  |                                               |^ |
   +-+-+-+-+-+-+-+-+                                               || |
   |                                                               || |
   |                    inner destination IP                       || |
   |                                                               || |a
   |               +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+| |u
   |               |          source port          |  dest. port   ~|e|t
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+|n|h
   ~  (continue)   |            TCP Sequence Number (SN)           ~|c|e
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+|r|n
   ~  (continue)   |    ACK Sequence Number (SN)                   ~|y|t
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+|p|i
   ~  (continue)   |Off. | Rserv |      Flags      | Window Size   ~|t|c
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+|e|a
   ~  (continue)   |             Checksum          |   Urgent      ~|d|t
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+| |e
   ~ Pointer       |                                               || |d
   +-+-+-+-+-+-+-+-+                                               || |
   ~                        APPLICATION DATA                       ~| |
   |                                                               || |
   |                                                               |v v
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+---
   |         Integrity Check Value-ICV   (variable)                |
   |                                                               |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

```
</font>

---
# EHC Strategy: Diet-ESP - Performance

M3 devices from INRIA's IoT-LAB platform
* IEEE 802.15.4
* Contiki 2.7 OS 

Radio Packet are 127 byte long
* 80 bytes for the IP packet

Diet-ESP overhead over uncenrcypted is less 2%

Diet-ESP cuts the bill:
* up to 100% for a 10 byte payload
* up to 30 % for a 190 byte payload 

---
# EHC Strategy: Diet-ESP - Performance


<img src="https://github.com/mglt/lecture-ipsec-iot/blob/master/fig/results_energy_vs_payload.png  " height="500">


---
# EHC Strategy: Diet-ESP - Performance


<img src="https://github.com/mglt/lecture-ipsec-iot/blob/master/fig/results_energy_vs_payload_relative.png" height="500">

---
# EHC Strategy: Diet-ESP - IKEv2 

Enabling Diet-ESP requires the agreement of:
* The EHC Strategy: ehc_strategy
* The necessary parameters
 * esp_sn_lsb
 * esp_spi_lsb
 * esp_align
 * udplite_coverage
 * tcp_lsb
 * tcp_options
 * tcp_urgent

---
# EHC Strategy: Diet-ESP - IKEv2 

Agreement is performed using IKEv2
* Exchange of EHC_STRATEGY_SUPPORTED Notify Payload
  
The Initiator provides:
* Acceptable value range for each parameters
* Default range values limit the size of the payloads
  * Default ehc_strategy is set to Diet-ESP
  * Default range: accept everything

The Responder provides:
* Acceptable chosen value for each parameters
* Default values limit the size of the payloads


---
# EHC Strategy: Diet-ESP - IKEv2 

| Parameter       | Value | Description                   
------------------|-------|-------------------------------
|   ehc_strategy  | 0*     |  Diet-ESP                    
|   esp_align     | 0*, 1, 2 |  8, 16, 32 bit alignment    
|   esp_spi_lsb   |  0*, 1, 2, 3, 4    |    0, 8, 16, 24, 32 bit length SPI 
|   esp_sn_lsb    |   0*, 1, 2, 3, 4    |    0, 8, 16, 24, 32 bit length SN 
|   tcp_urgent    |   0, 1*   |     Urgent pointer field compressed, uncompressed 
|   tcp_options   |   0, 1*   |     TCP option field compressed, uncompressed    |   tcp_lsb       | 0*, 1, 2, 3, 4    |    0, 8, 16, 24, 32 bit length SN 
|   udplite_coverage| 0*   |     Coverage is UDP Length           |
|                 |   8-65535 | Coverage 8 (the UDP-Lite Header) |


---
# EHC Strategy: Diet-ESP - IKEv2 

<font size="5">

```
  Initiator                         Responder
   -------------------------------------------------------------------
   HDR, SA, KEi, Ni -->
                                <-- HDR, SA, KEr, Nr
   HDR, SK {IDi, AUTH,
        SA, TSi, TSr,
        N(EHC_STRATEGY_SUPPORTED)} -->
                                <-- HDR, SK {IDr, AUTH,
                                         SA, TSi, TSr,
                                         N(EHC_STRATEGY_SUPPORTED)
```
</font>

---
# EHC Strategy: Diet-ESP - IKEv2 

EHC_STRATEGY_SUPPORTED Notify Payload

<font size="5">

```
      1                   2                   3
      0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
     | Next Payload  |C|  RESERVED   |         Payload Length        |
     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
     |  Protocol ID  |   SPI Size    |      Notify Message Type      |
     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```
</font>

EHC Strategy Configuration Parameter Attributes
<font size="5">

```
                          1                   2                   3
       0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
      +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
      |A|       Attribute Type        |    AF=0  Attribute Length     |
      |F|                             |    AF=1  Attribute Value      |
      +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
      |                   AF=0  Attribute Data                        |
      |                   AF=1  Not Transmitted                       |
      +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

```
</font>

---
# References

JOSE
COSE
OSCORE
CoAP
DTLS
TLS
IPsec
Diet ESP



