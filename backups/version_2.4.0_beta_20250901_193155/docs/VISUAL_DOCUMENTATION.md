# Visual Documentation: Homelab Architecture & Diagrams

## Table of Contents

1. [System Architecture Overview](#system-architecture-overview)
2. [Network Topology](#network-topology)
3. [Data Flow Diagrams](#data-flow-diagrams)
4. [Service Interaction Charts](#service-interaction-charts)
5. [Deployment Flow Diagrams](#deployment-flow-diagrams)
6. [Security Architecture](#security-architecture)
7. [Backup & Recovery Flow](#backup--recovery-flow)
8. [Monitoring Architecture](#monitoring-architecture)

---

## System Architecture Overview

### High-Level Architecture
```
┌─────────────────────────────────────────────────────────────────┐
│                        HOMELAB INFRASTRUCTURE                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────────┐    ┌─────────────────┐    ┌──────────────┐ │
│  │   WEB LAYER     │    │  APPLICATION    │    │   STORAGE    │ │
│  │                 │    │     LAYER       │    │    LAYER     │ │
│  │ • Traefik       │    │ • Jellyfin      │    │ • Local      │ │
│  │ • Authentik     │    │ • Sonarr        │    │ • Cloud      │ │
│  │ • Homepage      │    │ • Radarr        │    │ • Backup     │ │
│  │ • Grafana       │    │ • Paperless     │    │ • Archive    │ │
│  └─────────────────┘    │ • Monitoring    │    └──────────────┘ │
│                         └─────────────────┘                     │
│                                                                 │
│  ┌─────────────────┐    ┌─────────────────┐    ┌──────────────┐ │
│  │   SECURITY      │    │   AUTOMATION    │    │   NETWORK    │ │
│  │     LAYER       │    │     LAYER       │    │    LAYER     │ │
│  │ • Firewall      │    │ • Ansible       │    │ • DNS        │ │
│  │ • VPN           │    │ • Cron Jobs     │    │ • DHCP       │ │
│  │ • IDS/IPS       │    │ • Webhooks      │    │ • Routing    │ │
│  └─────────────────┘    └─────────────────┘    └──────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### Container Architecture
```
┌─────────────────────────────────────────────────────────────────┐
│                        DOCKER CONTAINERS                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────┐ │
│  │   Traefik   │  │  Authentik  │  │  Homepage   │  │ Grafana │ │
│  │ (Reverse    │  │ (Identity   │  │ (Dashboard) │  │(Monitor)│ │
│  │  Proxy)     │  │ Provider)   │  │             │  │         │ │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────┘ │
│                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────┐ │
│  │  Jellyfin   │  │   Sonarr    │  │   Radarr    │  │ Lidarr  │ │
│  │ (Media      │  │ (TV Shows)  │  │ (Movies)    │  │(Music)  │ │
│  │  Server)    │  │             │  │             │  │         │ │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────┘ │
│                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────┐ │
│  │ Paperless   │  │   Pihole    │  │   Uptime    │  │ Loki    │ │
│  │ (Documents) │  │ (DNS/Ad     │  │ (Monitoring)│  │(Logs)   │ │
│  │             │  │  Blocking)  │  │             │  │         │ │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────┘ │
│                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────┐ │
│  │   Prometheus│  │ Alertmanager│  │   Redis     │  │Database │ │
│  │ (Metrics)   │  │ (Alerts)    │  │ (Cache)     │  │(Storage)│ │
│  │             │  │             │  │             │  │         │ │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

---

## Network Topology

### Physical Network Layout
```
                    INTERNET
                       │
                       ▼
                ┌─────────────┐
                │   ROUTER    │
                │ (ISP Modem) │
                └─────────────┘
                       │
                       ▼
                ┌─────────────┐
                │   FIREWALL  │
                │ (pfsense/   │
                │  iptables)  │
                └─────────────┘
                       │
                       ▼
        ┌─────────────────────────────┐
        │         SWITCH              │
        │    (Network Hub)            │
        └─────────────────────────────┘
                       │
        ┌──────────────┼──────────────┐
        ▼              ▼              ▼
┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│   HOMELAB   │ │   DESKTOP   │ │   MOBILE    │
│   SERVER    │ │  COMPUTER   │ │   DEVICES   │
│             │ │             │ │             │
│ • Docker    │ │ • Windows   │ │ • Phones    │
│ • Services  │ │ • Mac       │ │ • Tablets   │
│ • Storage   │ │ • Linux     │ │ • Laptops   │
└─────────────┘ └─────────────┘ └─────────────┘
```

### Logical Network Architecture
```
                    INTERNET
                       │
                       ▼
                ┌─────────────┐
                │   DMZ       │
                │ (Port 80/443)│
                └─────────────┘
                       │
                       ▼
                ┌─────────────┐
                │   TRAEFIK   │
                │ (Reverse    │
                │  Proxy)     │
                └─────────────┘
                       │
                       ▼
        ┌─────────────────────────────┐
        │      AUTHENTICATION         │
        │      (Authentik)            │
        └─────────────────────────────┘
                       │
        ┌──────────────┼──────────────┐
        ▼              ▼              ▼
┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│   PUBLIC    │ │  INTERNAL   │ │  PRIVATE    │
│  SERVICES   │ │  SERVICES   │ │  SERVICES   │
│             │ │             │ │             │
│ • Homepage  │ │ • Jellyfin  │ │ • Databases │
│ • Grafana   │ │ • Sonarr    │ │ • Monitoring│
│ • Paperless │ │ • Radarr    │ │ • Backups   │
└─────────────┘ └─────────────┘ └─────────────┘
```

### VLAN Configuration
```
                    INTERNET
                       │
                       ▼
                ┌─────────────┐
                │   ROUTER    │
                │ (VLAN 1)    │
                └─────────────┘
                       │
        ┌──────────────┼──────────────┐
        ▼              ▼              ▼
┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│   VLAN 10   │ │   VLAN 20   │ │   VLAN 30   │
│  GUEST      │ │  INTERNAL   │ │  MANAGEMENT │
│  NETWORK    │ │  NETWORK    │ │  NETWORK    │
│             │ │             │ │             │
│ • Isolated  │ │ • Homelab   │ │ • Admin     │
│ • Limited   │ │ • Services  │ │ • Monitoring│
│ • Internet  │ │ • Storage   │ │ • Backup    │
│   Only      │ │ • Media     │ │ • Logs      │
└─────────────┘ └─────────────┘ └─────────────┘
```

---

## Data Flow Diagrams

### Media Request Flow
```
USER REQUEST
     │
     ▼
┌─────────────┐
│   BROWSER   │
│  (Client)   │
└─────────────┘
     │
     ▼
┌─────────────┐
│   TRAEFIK   │
│ (Load       │
│  Balancer)  │
└─────────────┘
     │
     ▼
┌─────────────┐
│ AUTHENTIK   │
│ (Auth Check)│
└─────────────┘
     │
     ▼
┌─────────────┐
│  JELLYFIN   │
│ (Media      │
│  Server)    │
└─────────────┘
     │
     ▼
┌─────────────┐
│   STORAGE   │
│ (Local/     │
│  Network)   │
└─────────────┘
     │
     ▼
┌─────────────┐
│   MEDIA     │
│  FILES      │
└─────────────┘
```

### Backup Flow
```
SCHEDULED BACKUP
     │
     ▼
┌─────────────┐
│   CRON      │
│ (Scheduler) │
└─────────────┘
     │
     ▼
┌─────────────┐
│  ANSIBLE    │
│ (Automation)│
└─────────────┘
     │
     ▼
┌─────────────┐
│   BACKUP    │
│  SCRIPT     │
└─────────────┘
     │
     ▼
┌─────────────┐
│   DOCKER    │
│ (Container  │
│  Backup)    │
└─────────────┘
     │
     ▼
┌─────────────┐
│   STORAGE   │
│ (Local/     │
│  Cloud)     │
└─────────────┘
     │
     ▼
┌─────────────┐
│  VERIFY     │
│ (Integrity  │
│  Check)     │
└─────────────┘
     │
     ▼
┌─────────────┐
│  NOTIFY     │
│ (Success/   │
│  Failure)   │
└─────────────┘
```

### Monitoring Flow
```
SYSTEM METRICS
     │
     ▼
┌─────────────┐
│  PROMETHEUS │
│ (Collector) │
└─────────────┘
     │
     ▼
┌─────────────┐
│   GRAFANA   │
│ (Visualize) │
└─────────────┘
     │
     ▼
┌─────────────┐
│  ALERTING   │
│ (Rules)     │
└─────────────┘
     │
     ▼
┌─────────────┐
│ALERTMANAGER │
│ (Processor) │
└─────────────┘
     │
     ▼
┌─────────────┐
│  NOTIFY     │
│ (Email/     │
│  Discord)   │
└─────────────┘
```

---

## Service Interaction Charts

### Media Services Interaction
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   SONARR    │    │   RADARR    │    │   LIDARR    │
│ (TV Shows)  │    │ (Movies)    │    │ (Music)     │
└─────────────┘    └─────────────┘    └─────────────┘
       │                   │                   │
       └───────────────────┼───────────────────┘
                           │
                           ▼
                   ┌─────────────┐
                   │  SABNZBD    │
                   │ (Download   │
                   │  Client)    │
                   └─────────────┘
                           │
                           ▼
                   ┌─────────────┐
                   │  JELLYFIN   │
                   │ (Media      │
                   │  Server)    │
                   └─────────────┘
                           │
                           ▼
                   ┌─────────────┐
                   │   USERS     │
                   │ (Viewers)   │
                   └─────────────┘
```

### Security Services Interaction
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   PIHOLE    │    │  FAIL2BAN   │    │   CROWD     │
│ (DNS/Ad     │    │ (Intrusion  │    │   SEC       │
│  Blocking)  │    │  Detection) │    │ (Threat     │
└─────────────┘    └─────────────┘    │  Intel)     │
       │                   │          └─────────────┘
       └───────────────────┼──────────────────┘
                           │
                           ▼
                   ┌─────────────┐
                   │   LOGS      │
                   │ (Centralized│
                   │  Logging)   │
                   └─────────────┘
                           │
                           ▼
                   ┌─────────────┐
                   │  GRAFANA    │
                   │ (Security   │
                   │  Dashboard) │
                   └─────────────┘
```

### Authentication Flow
```
USER LOGIN
     │
     ▼
┌─────────────┐
│   TRAEFIK   │
│ (Route to   │
│  Auth)      │
└─────────────┘
     │
     ▼
┌─────────────┐
│ AUTHENTIK   │
│ (Identity   │
│  Provider)  │
└─────────────┘
     │
     ▼
┌─────────────┐
│   LDAP      │
│ (User       │
│  Directory) │
└─────────────┘
     │
     ▼
┌─────────────┐
│   SERVICE   │
│ (Jellyfin,  │
│  Grafana,   │
│  etc.)      │
└─────────────┘
```

---

## Deployment Flow Diagrams

### Initial Deployment Flow
```
START DEPLOYMENT
     │
     ▼
┌─────────────┐
│  PREREQ     │
│ CHECK       │
└─────────────┘
     │
     ▼
┌─────────────┐
│  ANSIBLE    │
│  PLAYBOOK   │
└─────────────┘
     │
     ▼
┌─────────────┐
│  SYSTEM     │
│  SETUP      │
└─────────────┘
     │
     ▼
┌─────────────┐
│   DOCKER    │
│  INSTALL    │
└─────────────┘
     │
     ▼
┌─────────────┐
│  SERVICES   │
│  DEPLOY     │
└─────────────┘
     │
     ▼
┌─────────────┐
│  CONFIGURE  │
│  SERVICES   │
└─────────────┘
     │
     ▼
┌─────────────┐
│  VALIDATE   │
│  DEPLOYMENT │
└─────────────┘
     │
     ▼
┌─────────────┐
│  MONITORING │
│  SETUP      │
└─────────────┘
     │
     ▼
┌─────────────┐
│  BACKUP     │
│  CONFIGURE  │
└─────────────┘
     │
     ▼
┌─────────────┐
│  DEPLOYMENT │
│  COMPLETE   │
└─────────────┘
```

### Service Update Flow
```
UPDATE TRIGGER
     │
     ▼
┌─────────────┐
│  BACKUP     │
│  CURRENT    │
└─────────────┘
     │
     ▼
┌─────────────┐
│  PULL NEW   │
│  IMAGE      │
└─────────────┘
     │
     ▼
┌─────────────┐
│  STOP OLD   │
│  CONTAINER  │
└─────────────┘
     │
     ▼
┌─────────────┐
│  START NEW  │
│  CONTAINER  │
└─────────────┘
     │
     ▼
┌─────────────┐
│  HEALTH     │
│  CHECK      │
└─────────────┘
     │
     ▼
┌─────────────┐
│  ROLLBACK   │
│  IF FAILED  │
└─────────────┘
```

---

## Security Architecture

### Security Layers
```
                    INTERNET
                       │
                       ▼
                ┌─────────────┐
                │   FIREWALL  │
                │ (Network    │
                │  Level)     │
                └─────────────┘
                       │
                       ▼
                ┌─────────────┐
                │   TRAEFIK   │
                │ (Application│
                │  Level)     │
                └─────────────┘
                       │
                       ▼
                ┌─────────────┐
                │ AUTHENTIK   │
                │ (Identity   │
                │  & Access)  │
                └─────────────┘
                       │
                       ▼
                ┌─────────────┐
                │   SERVICE   │
                │ (Individual │
                │  Security)  │
                └─────────────┘
                       │
                       ▼
                ┌─────────────┐
                │   DATA      │
                │ (Encryption)│
                └─────────────┘
```

### Threat Protection
```
┌─────────────────────────────────────────────────────────────────┐
│                        THREAT PROTECTION                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────┐ │
│  │   PIHOLE    │  │  FAIL2BAN   │  │   CROWD     │  │   VPN   │ │
│  │ (DNS/Ad     │  │ (Brute      │  │   SEC       │  │(Remote  │ │
│  │  Blocking)  │  │  Force)     │  │ (Threat     │  │ Access) │ │
│  └─────────────┘  └─────────────┘  │  Intel)     │  └─────────┘ │
│                                    └─────────────┘             │
│                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────┐ │
│  │   FIREWALL  │  │   IDS/IPS   │  │   LOGS      │  │ MONITOR │ │
│  │ (Network    │  │ (Intrusion  │  │ (Security   │  │(Real-   │ │
│  │  Filtering) │  │  Detection) │  │  Events)    │  │ Time)   │ │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────┘ │
│                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────┐ │
│  │   BACKUP    │  │ ENCRYPTION  │  │   ACCESS    │  │  AUDIT  │ │
│  │ (Data       │  │ (At Rest)   │  │   CONTROL   │  │(Logging)│ │
│  │  Protection)│  │             │  │ (RBAC)      │  │         │ │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

---

## Backup & Recovery Flow

### Backup Strategy
```
┌─────────────────────────────────────────────────────────────────┐
│                        BACKUP STRATEGY                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────┐ │
│  │   DAILY     │  │   WEEKLY    │  │   MONTHLY   │  │  YEARLY │ │
│  │ (Incremental│  │ (Differential│  │ (Full       │  │ (Archive│ │
│  │  Backup)    │  │  Backup)     │  │  Backup)    │  │  Backup)│ │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────┘ │
│                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────┐ │
│  │   LOCAL     │  │   CLOUD     │  │   OFFSITE   │  │ VERIFY  │ │
│  │ (Fast       │  │ (Remote     │  │ (Physical   │  │(Integrity│ │
│  │  Recovery)  │  │  Storage)   │  │  Storage)   │  │  Check) │ │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### Recovery Process
```
DISASTER EVENT
     │
     ▼
┌─────────────┐
│  ASSESS     │
│  DAMAGE     │
└─────────────┘
     │
     ▼
┌─────────────┐
│  CHOOSE     │
│  BACKUP     │
└─────────────┘
     │
     ▼
┌─────────────┐
│  RESTORE    │
│  SYSTEM     │
└─────────────┘
     │
     ▼
┌─────────────┐
│  VERIFY     │
│  SERVICES   │
└─────────────┘
     │
     ▼
┌─────────────┐
│  TEST       │
│  FUNCTIONAL │
└─────────────┘
     │
     ▼
┌─────────────┐
│  MONITOR    │
│  STABILITY  │
└─────────────┘
```

---

## Monitoring Architecture

### Monitoring Stack
```
┌─────────────────────────────────────────────────────────────────┐
│                        MONITORING STACK                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────┐ │
│  │  PROMETHEUS │  │   GRAFANA   │  │ ALERTMANAGER│  │   LOKI  │ │
│  │ (Metrics    │  │ (Visualize) │  │ (Alert      │  │ (Logs)  │ │
│  │  Collector) │  │             │  │  Processor) │  │         │ │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────┘ │
│                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────┐ │
│  │   UPTIME    │  │   PING      │  │   HEALTH    │  │  STATS  │ │
│  │ (Service    │  │ (Network    │  │   CHECKS    │  │(System  │ │
│  │  Monitoring)│  │  Monitoring)│  │ (Endpoints) │  │ Metrics)│ │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────┘ │
│                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────┐ │
│  │   EMAIL     │  │  DISCORD    │  │   SLACK     │  │  WEBHOOK│ │
│  │ (Alerts)    │  │ (Alerts)    │  │ (Alerts)    │  │(Custom  │ │
│  │             │  │             │  │             │  │ Alerts) │ │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### Metrics Collection
```
┌─────────────────────────────────────────────────────────────────┐
│                        METRICS COLLECTION                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────┐ │
│  │   SYSTEM    │  │  CONTAINER  │  │  SERVICE    │  │ NETWORK │ │
│  │ (CPU, RAM,  │  │ (Docker     │  │  Metrics)   │  │ (Band-  │ │
│  │  Disk)      │  │  Stats)     │  │             │  │  Width) │ │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────┘ │
│                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────┐ │
│  │   SECURITY  │  │   BACKUP    │  │   STORAGE   │  │  CUSTOM │ │
│  │ (Failed     │  │ (Success/   │  │ (Usage/     │  │ (User   │ │
│  │  Logins)    │  │  Failure)   │  │  Capacity)  │  │  Defined)│ │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

---

## Conclusion

This visual documentation provides a comprehensive overview of the homelab architecture, network topology, data flows, and system interactions. These diagrams help both technical and non-technical users understand:

1. **How the system is organized** - Architecture and component relationships
2. **How data flows** - Request/response patterns and data movement
3. **How services interact** - Dependencies and communication patterns
4. **How security is implemented** - Multi-layered protection approach
5. **How monitoring works** - Comprehensive observability strategy
6. **How backups and recovery function** - Data protection and disaster recovery

These visual aids complement the existing text-based documentation and provide quick reference for understanding system behavior and troubleshooting issues. 