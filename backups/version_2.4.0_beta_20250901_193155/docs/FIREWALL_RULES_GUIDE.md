# Homelab Firewall Rules Guide

## Overview

This guide provides comprehensive firewall rules for routing traffic through your homelab infrastructure. The rules are designed for enterprise-grade firewalls and follow security best practices for protecting your services while maintaining accessibility.

## 🏗️ **Network Architecture**

### **Network Segments**
```
Internet → Firewall → DMZ → Internal Services
                ↓
            Management Network
                ↓
            Service Networks
```

### **IP Address Ranges**
- **WAN**: Your public IP (assigned by ISP)
- **LAN**: 192.168.1.0/24 (main network)
- **DMZ**: 192.168.10.0/24 (external services)
- **Management**: 192.168.20.0/24 (admin services)
- **Services**: 192.168.30.0/24 (internal services)
- **IoT**: 192.168.40.0/24 (smart devices)
- **Guest**: 192.168.50.0/24 (guest network)

## 🔒 **Firewall Rule Categories**

### **1. WAN to LAN Rules (Inbound)**
### **2. LAN to WAN Rules (Outbound)**
### **3. Internal Network Rules**
### **4. Service-Specific Rules**
### **5. Security Rules**
### **6. Management Rules**

---

## 📋 **Rule Set Implementation**

### **Category 1: WAN to LAN Rules (Inbound)**

#### **Rule 1.1: HTTPS Traffic (Port 443)**
```
Rule Name: WAN_HTTPS_Allow
Action: Allow
Protocol: TCP
Source: Any
Destination: WAN Interface
Destination Port: 443
Description: Allow HTTPS traffic from internet to homelab services
Logging: Enabled
```

#### **Rule 1.2: HTTP Traffic (Port 80)**
```
Rule Name: WAN_HTTP_Allow
Action: Allow
Protocol: TCP
Source: Any
Destination: WAN Interface
Destination Port: 80
Description: Allow HTTP traffic for SSL redirects
Logging: Enabled
```

#### **Rule 1.3: SSH Access (Port 22)**
```
Rule Name: WAN_SSH_Allow
Action: Allow
Protocol: TCP
Source: [Your Trusted IPs]
Destination: WAN Interface
Destination Port: 22
Description: Allow SSH access from trusted IPs only
Logging: Enabled
```

#### **Rule 1.4: VPN Access (Port 1194)**
```
Rule Name: WAN_VPN_Allow
Action: Allow
Protocol: UDP
Source: Any
Destination: WAN Interface
Destination Port: 1194
Description: Allow VPN access for remote connectivity
Logging: Enabled
```

#### **Rule 1.5: DNS Traffic (Port 53)**
```
Rule Name: WAN_DNS_Allow
Action: Allow
Protocol: UDP/TCP
Source: Any
Destination: WAN Interface
Destination Port: 53
Description: Allow DNS queries to Pi-hole
Logging: Enabled
```

### **Category 2: LAN to WAN Rules (Outbound)**

#### **Rule 2.1: Internet Access**
```
Rule Name: LAN_Internet_Allow
Action: Allow
Protocol: Any
Source: LAN Network
Destination: Any
Description: Allow LAN devices to access internet
Logging: Disabled
```

#### **Rule 2.2: DNS Outbound**
```
Rule Name: LAN_DNS_Outbound
Action: Allow
Protocol: UDP/TCP
Source: LAN Network
Destination: Any
Destination Port: 53
Description: Allow DNS queries to external servers
Logging: Enabled
```

#### **Rule 2.3: NTP Traffic**
```
Rule Name: LAN_NTP_Allow
Action: Allow
Protocol: UDP
Source: LAN Network
Destination: Any
Destination Port: 123
Description: Allow NTP time synchronization
Logging: Disabled
```

### **Category 3: Internal Network Rules**

#### **Rule 3.1: LAN to DMZ Access**
```
Rule Name: LAN_DMZ_Allow
Action: Allow
Protocol: Any
Source: LAN Network
Destination: DMZ Network
Description: Allow LAN devices to access DMZ services
Logging: Enabled
```

#### **Rule 3.2: LAN to Management Access**
```
Rule Name: LAN_Management_Allow
Action: Allow
Protocol: Any
Source: LAN Network
Destination: Management Network
Description: Allow LAN devices to access management services
Logging: Enabled
```

#### **Rule 3.3: DMZ to LAN Access**
```
Rule Name: DMZ_LAN_Deny
Action: Deny
Protocol: Any
Source: DMZ Network
Destination: LAN Network
Description: Prevent DMZ from accessing LAN (security isolation)
Logging: Enabled
```

#### **Rule 3.4: Management to Services**
```
Rule Name: Management_Services_Allow
Action: Allow
Protocol: Any
Source: Management Network
Destination: Services Network
Description: Allow management access to internal services
Logging: Enabled
```

### **Category 4: Service-Specific Rules**

#### **Rule 4.1: Web Services (HTTP/HTTPS)**
```
Rule Name: Web_Services_Allow
Action: Allow
Protocol: TCP
Source: Any
Destination: [Web Server IPs]
Destination Port: 80, 443
Description: Allow access to web services (Nginx Proxy Manager, Homepage)
Logging: Enabled
```

#### **Rule 4.2: Media Services**
```
Rule Name: Media_Services_Allow
Action: Allow
Protocol: TCP
Source: LAN Network
Destination: [Media Server IPs]
Destination Port: 8096, 8989, 7878, 6767
Description: Allow access to media services (Jellyfin, Sonarr, Radarr, Bazarr)
Logging: Enabled
```

#### **Rule 4.3: Database Services**
```
Rule Name: Database_Services_Allow
Action: Allow
Protocol: TCP
Source: Services Network
Destination: [Database Server IPs]
Destination Port: 3306, 5432, 6379
Description: Allow internal services to access databases
Logging: Enabled
```

#### **Rule 4.4: Monitoring Services**
```
Rule Name: Monitoring_Services_Allow
Action: Allow
Protocol: TCP
Source: Management Network
Destination: [Monitoring Server IPs]
Destination Port: 3000, 9090, 9091, 8080
Description: Allow access to monitoring services (Grafana, Prometheus, AlertManager)
Logging: Enabled
```

#### **Rule 4.5: Authentication Services**
```
Rule Name: Auth_Services_Allow
Action: Allow
Protocol: TCP
Source: Any
Destination: [Auth Server IPs]
Destination Port: 9000
Description: Allow access to authentication services (Authentik)
Logging: Enabled
```

### **Category 5: Security Rules**

#### **Rule 5.1: Block Common Attack Ports**
```
Rule Name: Block_Attack_Ports
Action: Deny
Protocol: Any
Source: Any
Destination: Any
Destination Port: 22, 23, 25, 135, 139, 445, 1433, 1521, 3306, 3389, 5432, 6379, 27017
Description: Block commonly attacked ports from external sources
Logging: Enabled
```

#### **Rule 5.2: Block ICMP Flood**
```
Rule Name: Block_ICMP_Flood
Action: Deny
Protocol: ICMP
Source: Any
Destination: Any
Description: Block ICMP flood attacks
Logging: Enabled
```

#### **Rule 5.3: Block Invalid Packets**
```
Rule Name: Block_Invalid_Packets
Action: Deny
Protocol: Any
Source: Any
Destination: Any
Description: Block packets with invalid flags or states
Logging: Enabled
```

#### **Rule 5.4: Rate Limiting**
```
Rule Name: Rate_Limit_Connections
Action: Allow with Rate Limit
Protocol: Any
Source: Any
Destination: Any
Rate Limit: 100 connections per minute per IP
Description: Rate limit connections to prevent DoS attacks
Logging: Enabled
```

### **Category 6: Management Rules**

#### **Rule 6.1: Admin Access**
```
Rule Name: Admin_Access_Allow
Action: Allow
Protocol: Any
Source: [Admin IPs]
Destination: Management Network
Description: Allow admin access to management services
Logging: Enabled
```

#### **Rule 6.2: Backup Services**
```
Rule Name: Backup_Services_Allow
Action: Allow
Protocol: TCP
Source: Services Network
Destination: [Backup Server IPs]
Destination Port: 22, 873
Description: Allow backup services to access backup storage
Logging: Enabled
```

#### **Rule 6.3: Monitoring Traffic**
```
Rule Name: Monitoring_Traffic_Allow
Action: Allow
Protocol: Any
Source: Services Network
Destination: [Monitoring Server IPs]
Description: Allow services to send metrics to monitoring
Logging: Disabled
```

---

## 🔧 **Implementation Instructions**

### **Step 1: Network Configuration**

1. **Configure Network Interfaces**:
   - Set up VLANs for different network segments
   - Configure IP addressing for each segment
   - Enable DHCP for each network segment

2. **Configure Routing**:
   - Set up static routes between network segments
   - Configure default gateway for internet access
   - Enable NAT for outbound internet access

### **Step 2: Firewall Rule Creation**

1. **Create Rule Groups**:
   - Group rules by category for easier management
   - Use descriptive names for all rules
   - Enable logging for security rules

2. **Rule Order**:
   - Place specific rules before general rules
   - Place allow rules before deny rules
   - Place security rules at the top

3. **Rule Testing**:
   - Test each rule individually
   - Verify logging is working correctly
   - Monitor rule hit counts

### **Step 3: Service-Specific Configuration**

#### **Web Services Configuration**
```
Service: Nginx Proxy Manager
Ports: 80, 443
Source: Any
Destination: 192.168.10.10
Action: Allow
Logging: Enabled
```

#### **Media Services Configuration**
```
Service: Jellyfin, Sonarr, Radarr
Ports: 8096, 8989, 7878, 6767
Source: LAN Network
Destination: 192.168.30.10-192.168.30.20
Action: Allow
Logging: Enabled
```

#### **Database Services Configuration**
```
Service: PostgreSQL, MySQL, Redis
Ports: 5432, 3306, 6379
Source: Services Network
Destination: 192.168.30.30-192.168.30.40
Action: Allow
Logging: Enabled
```

### **Step 4: Security Hardening**

1. **Enable Intrusion Prevention**:
   - Configure IPS signatures for common attacks
   - Enable anomaly detection
   - Set up alerting for security events

2. **Configure DDoS Protection**:
   - Enable SYN flood protection
   - Configure connection rate limiting
   - Set up blacklisting for malicious IPs

3. **Enable Deep Packet Inspection**:
   - Configure application layer filtering
   - Enable SSL/TLS inspection
   - Set up content filtering

### **Step 5: Monitoring and Alerting**

1. **Configure Logging**:
   - Enable logging for all security rules
   - Set up log rotation and retention
   - Configure log forwarding to monitoring system

2. **Set Up Alerting**:
   - Configure alerts for failed login attempts
   - Set up alerts for unusual traffic patterns
   - Configure alerts for rule violations

3. **Performance Monitoring**:
   - Monitor firewall CPU and memory usage
   - Track rule hit counts and performance
   - Monitor network throughput and latency

---

## 📊 **Rule Priority Matrix**

| Priority | Rule Type | Description |
|----------|-----------|-------------|
| 1 | Security Rules | Block malicious traffic first |
| 2 | Service Rules | Allow specific service access |
| 3 | Network Rules | Allow internal network communication |
| 4 | Internet Rules | Allow outbound internet access |
| 5 | Default Deny | Block all other traffic |

---

## 🔍 **Troubleshooting Guide**

### **Common Issues**

#### **1. Service Not Accessible**
```
Checklist:
□ Verify firewall rule exists for service
□ Check rule is enabled and active
□ Verify source and destination IPs
□ Check rule order and priority
□ Review firewall logs for blocked traffic
```

#### **2. Performance Issues**
```
Checklist:
□ Monitor firewall CPU usage
□ Check rule hit counts
□ Review logging verbosity
□ Optimize rule order
□ Consider rule consolidation
```

#### **3. Security Alerts**
```
Checklist:
□ Review security event logs
□ Check for new attack patterns
□ Update IPS signatures
□ Review blocked IP addresses
□ Verify security rule effectiveness
```

### **Debugging Commands**

#### **Check Rule Status**
```bash
# View active firewall rules
show firewall rules

# Check rule hit counts
show firewall rule statistics

# View blocked traffic
show firewall logs
```

#### **Test Connectivity**
```bash
# Test port connectivity
telnet [destination_ip] [port]

# Test service accessibility
curl -I http://[service_ip]:[port]

# Check routing
traceroute [destination_ip]
```

---

## 🛡️ **Security Best Practices**

### **1. Rule Management**
- **Regular Review**: Review firewall rules monthly
- **Documentation**: Document all rule changes
- **Testing**: Test rules in staging environment first
- **Backup**: Backup firewall configuration regularly

### **2. Access Control**
- **Principle of Least Privilege**: Only allow necessary access
- **Network Segmentation**: Isolate different network segments
- **Service Isolation**: Separate public and private services
- **Monitoring**: Monitor all access attempts

### **3. Threat Prevention**
- **IPS/IDS**: Enable intrusion prevention/detection
- **DDoS Protection**: Configure DDoS mitigation
- **Content Filtering**: Filter malicious content
- **SSL Inspection**: Inspect encrypted traffic when possible

### **4. Compliance**
- **Logging**: Maintain comprehensive logs
- **Retention**: Follow log retention policies
- **Auditing**: Regular security audits
- **Documentation**: Maintain security documentation

---

## 📈 **Performance Optimization**

### **1. Rule Optimization**
- **Consolidate Rules**: Combine similar rules
- **Optimize Order**: Place frequently used rules first
- **Use Aliases**: Use IP/port aliases for efficiency
- **Disable Unused Rules**: Remove unnecessary rules

### **2. Hardware Optimization**
- **Resource Monitoring**: Monitor CPU and memory usage
- **Load Balancing**: Distribute traffic across interfaces
- **Caching**: Enable connection caching
- **Offloading**: Use hardware offloading when available

### **3. Network Optimization**
- **Traffic Shaping**: Prioritize important traffic
- **QoS**: Configure quality of service
- **Bandwidth Management**: Monitor bandwidth usage
- **Latency Optimization**: Optimize routing paths

---

## 🔮 **Advanced Features**

### **1. High Availability**
- **Failover Configuration**: Set up primary/backup firewalls
- **Load Balancing**: Distribute traffic across multiple firewalls
- **Synchronization**: Sync configurations between firewalls
- **Monitoring**: Monitor firewall health and status

### **2. Advanced Security**
- **Threat Intelligence**: Integrate with threat intelligence feeds
- **Machine Learning**: Use ML for anomaly detection
- **Behavioral Analysis**: Analyze traffic patterns
- **Automated Response**: Configure automated threat response

### **3. Integration**
- **SIEM Integration**: Integrate with security information systems
- **API Integration**: Use APIs for automated management
- **Cloud Integration**: Integrate with cloud security services
- **Mobile Management**: Enable mobile device management

---

## 📋 **Maintenance Checklist**

### **Monthly Tasks**
- [ ] Review firewall rule effectiveness
- [ ] Update security signatures
- [ ] Review blocked traffic logs
- [ ] Check performance metrics
- [ ] Update documentation

### **Quarterly Tasks**
- [ ] Security audit and penetration testing
- [ ] Rule optimization and cleanup
- [ ] Performance tuning
- [ ] Backup configuration
- [ ] Update security policies

### **Annual Tasks**
- [ ] Comprehensive security review
- [ ] Hardware/software upgrades
- [ ] Policy review and updates
- [ ] Disaster recovery testing
- [ ] Compliance audit

---

This comprehensive firewall rule set provides enterprise-grade security for your homelab while maintaining accessibility and performance. The rules are designed to be flexible and can be adapted to various firewall platforms and network configurations. 