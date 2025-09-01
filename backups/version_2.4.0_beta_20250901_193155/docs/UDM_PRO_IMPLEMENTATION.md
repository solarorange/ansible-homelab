# UDM Pro Firewall Implementation Guide

## Overview

This guide provides specific implementation instructions for configuring the Ubiquiti UDM Pro firewall for your homelab environment. The configuration follows enterprise security best practices while maintaining accessibility for your services.

## 🏗️ **Network Configuration**

### **Step 1: Network Setup**

#### **Create Network Segments**
1. **Navigate to**: Settings → Networks
2. **Create Networks**:
   ```
   LAN: 192.168.1.0/24 (Default)
   DMZ: 192.168.10.0/24
   Management: 192.168.20.0/24
   Services: 192.168.30.0/24
   IoT: 192.168.40.0/24
   Guest: 192.168.50.0/24
   ```

#### **Configure DHCP**
1. **LAN Network**:
   - Range: 192.168.1.10 - 192.168.1.254
   - Gateway: 192.168.1.1
   - DNS: 192.168.1.10 (Pi-hole)

2. **DMZ Network**:
   - Range: 192.168.10.10 - 192.168.10.254
   - Gateway: 192.168.10.1
   - DNS: 192.168.1.10

3. **Management Network**:
   - Range: 192.168.20.10 - 192.168.20.254
   - Gateway: 192.168.20.1
   - DNS: 192.168.1.10

4. **Services Network**:
   - Range: 192.168.30.10 - 192.168.30.254
   - Gateway: 192.168.30.1
   - DNS: 192.168.1.10

---

## 🔒 **Firewall Rules Configuration**

### **Step 2: Create Firewall Rules**

#### **Rule Group 1: WAN to LAN Rules**

**Rule 1.1: HTTPS Traffic**
```
Name: WAN_HTTPS_Allow
Action: Accept
Protocol: TCP
Source: Any
Destination: WAN Interface
Destination Port: 443
Description: Allow HTTPS traffic from internet
Logging: Enabled
```

**Rule 1.2: HTTP Traffic**
```
Name: WAN_HTTP_Allow
Action: Accept
Protocol: TCP
Source: Any
Destination: WAN Interface
Destination Port: 80
Description: Allow HTTP traffic for SSL redirects
Logging: Enabled
```

**Rule 1.3: SSH Access**
```
Name: WAN_SSH_Allow
Action: Accept
Protocol: TCP
Source: [Your Trusted IPs]
Destination: WAN Interface
Destination Port: 22
Description: Allow SSH access from trusted IPs
Logging: Enabled
```

**Rule 1.4: VPN Access**
```
Name: WAN_VPN_Allow
Action: Accept
Protocol: UDP
Source: Any
Destination: WAN Interface
Destination Port: 1194
Description: Allow VPN access
Logging: Enabled
```

**Rule 1.5: DNS Traffic**
```
Name: WAN_DNS_Allow
Action: Accept
Protocol: UDP/TCP
Source: Any
Destination: WAN Interface
Destination Port: 53
Description: Allow DNS queries to Pi-hole
Logging: Enabled
```

#### **Rule Group 2: LAN to WAN Rules**

**Rule 2.1: Internet Access**
```
Name: LAN_Internet_Allow
Action: Accept
Protocol: Any
Source: LAN Network
Destination: Any
Description: Allow LAN devices to access internet
Logging: Disabled
```

**Rule 2.2: DNS Outbound**
```
Name: LAN_DNS_Outbound
Action: Accept
Protocol: UDP/TCP
Source: LAN Network
Destination: Any
Destination Port: 53
Description: Allow DNS queries to external servers
Logging: Enabled
```

**Rule 2.3: NTP Traffic**
```
Name: LAN_NTP_Allow
Action: Accept
Protocol: UDP
Source: LAN Network
Destination: Any
Destination Port: 123
Description: Allow NTP time synchronization
Logging: Disabled
```

#### **Rule Group 3: Internal Network Rules**

**Rule 3.1: LAN to DMZ Access**
```
Name: LAN_DMZ_Allow
Action: Accept
Protocol: Any
Source: LAN Network
Destination: DMZ Network
Description: Allow LAN devices to access DMZ services
Logging: Enabled
```

**Rule 3.2: LAN to Management Access**
```
Name: LAN_Management_Allow
Action: Accept
Protocol: Any
Source: LAN Network
Destination: Management Network
Description: Allow LAN devices to access management services
Logging: Enabled
```

**Rule 3.3: DMZ to LAN Access**
```
Name: DMZ_LAN_Deny
Action: Drop
Protocol: Any
Source: DMZ Network
Destination: LAN Network
Description: Prevent DMZ from accessing LAN
Logging: Enabled
```

**Rule 3.4: Management to Services**
```
Name: Management_Services_Allow
Action: Accept
Protocol: Any
Source: Management Network
Destination: Services Network
Description: Allow management access to internal services
Logging: Enabled
```

#### **Rule Group 4: Service-Specific Rules**

**Rule 4.1: Web Services**
```
Name: Web_Services_Allow
Action: Accept
Protocol: TCP
Source: Any
Destination: 192.168.10.10
Destination Port: 80, 443
Description: Allow access to Nginx Proxy Manager
Logging: Enabled
```

**Rule 4.2: Media Services**
```
Name: Media_Services_Allow
Action: Accept
Protocol: TCP
Source: LAN Network
Destination: 192.168.30.10-192.168.30.20
Destination Port: 8096, 8989, 7878, 6767
Description: Allow access to media services
Logging: Enabled
```

**Rule 4.3: Database Services**
```
Name: Database_Services_Allow
Action: Accept
Protocol: TCP
Source: Services Network
Destination: 192.168.30.30-192.168.30.40
Destination Port: 3306, 5432, 6379
Description: Allow internal services to access databases
Logging: Enabled
```

**Rule 4.4: Monitoring Services**
```
Name: Monitoring_Services_Allow
Action: Accept
Protocol: TCP
Source: Management Network
Destination: 192.168.20.10-192.168.20.20
Destination Port: 3000, 9090, 9091, 8080
Description: Allow access to monitoring services
Logging: Enabled
```

**Rule 4.5: Authentication Services**
```
Name: Auth_Services_Allow
Action: Accept
Protocol: TCP
Source: Any
Destination: 192.168.10.20
Destination Port: 9000
Description: Allow access to Authentik
Logging: Enabled
```

#### **Rule Group 5: Security Rules**

**Rule 5.1: Block Common Attack Ports**
```
Name: Block_Attack_Ports
Action: Drop
Protocol: Any
Source: Any
Destination: Any
Destination Port: 22, 23, 25, 135, 139, 445, 1433, 1521, 3306, 3389, 5432, 6379, 27017
Description: Block commonly attacked ports
Logging: Enabled
```

**Rule 5.2: Block ICMP Flood**
```
Name: Block_ICMP_Flood
Action: Drop
Protocol: ICMP
Source: Any
Destination: Any
Description: Block ICMP flood attacks
Logging: Enabled
```

**Rule 5.3: Rate Limiting**
```
Name: Rate_Limit_Connections
Action: Accept with Rate Limit
Protocol: Any
Source: Any
Destination: Any
Rate Limit: 100 connections per minute per IP
Description: Rate limit connections
Logging: Enabled
```

#### **Rule Group 6: Management Rules**

**Rule 6.1: Admin Access**
```
Name: Admin_Access_Allow
Action: Accept
Protocol: Any
Source: [Admin IPs]
Destination: Management Network
Description: Allow admin access to management services
Logging: Enabled
```

**Rule 6.2: Backup Services**
```
Name: Backup_Services_Allow
Action: Accept
Protocol: TCP
Source: Services Network
Destination: 192.168.30.50
Destination Port: 22, 873
Description: Allow backup services
Logging: Enabled
```

**Rule 6.3: Monitoring Traffic**
```
Name: Monitoring_Traffic_Allow
Action: Accept
Protocol: Any
Source: Services Network
Destination: 192.168.20.10
Description: Allow services to send metrics
Logging: Disabled
```

---

## 🔧 **UDM Pro Specific Configuration**

### **Step 3: Enable Security Features**

#### **1. Enable Intrusion Prevention**
1. **Navigate to**: Security → Intrusion Prevention
2. **Enable**: Intrusion Prevention System (IPS)
3. **Configure**: Threat Management
   - Enable: All threat categories
   - Set sensitivity: High
   - Enable: Anomaly detection

#### **2. Configure DDoS Protection**
1. **Navigate to**: Security → DDoS Protection
2. **Enable**: DDoS Protection
3. **Configure**:
   - SYN flood protection: Enabled
   - Connection rate limiting: 1000 connections/second
   - Enable: Blacklisting for malicious IPs

#### **3. Enable Deep Packet Inspection**
1. **Navigate to**: Security → Deep Packet Inspection
2. **Enable**: DPI for all networks
3. **Configure**: Application layer filtering
4. **Enable**: SSL/TLS inspection (optional)

### **Step 4: Configure NAT Rules**

#### **Port Forwarding Rules**

**Rule 1: HTTPS Forwarding**
```
Name: HTTPS_Forward
Protocol: TCP
Source: Any
Destination: WAN Interface
Destination Port: 443
Forward To: 192.168.10.10:443
Description: Forward HTTPS to Nginx Proxy Manager
```

**Rule 2: HTTP Forwarding**
```
Name: HTTP_Forward
Protocol: TCP
Source: Any
Destination: WAN Interface
Destination Port: 80
Forward To: 192.168.10.10:80
Description: Forward HTTP to Nginx Proxy Manager
```

**Rule 3: SSH Forwarding**
```
Name: SSH_Forward
Protocol: TCP
Source: [Your Trusted IPs]
Destination: WAN Interface
Destination Port: 22
Forward To: 192.168.1.10:22
Description: Forward SSH to management server
```

**Rule 4: VPN Forwarding**
```
Name: VPN_Forward
Protocol: UDP
Source: Any
Destination: WAN Interface
Destination Port: 1194
Forward To: 192.168.1.10:1194
Description: Forward VPN traffic
```

### **Step 5: Configure Traffic Rules**

#### **QoS Configuration**
1. **Navigate to**: Settings → Traffic Management
2. **Create QoS Rules**:

**Rule 1: VoIP Priority**
```
Name: VoIP_Priority
Priority: High
Protocol: UDP
Source: Any
Destination: Any
Destination Port: 5060, 10000-20000
Description: Prioritize VoIP traffic
```

**Rule 2: Gaming Priority**
```
Name: Gaming_Priority
Priority: High
Protocol: UDP
Source: Any
Destination: Any
Destination Port: 27015, 27016, 27017
Description: Prioritize gaming traffic
```

**Rule 3: Streaming Priority**
```
Name: Streaming_Priority
Priority: Medium
Protocol: TCP
Source: Any
Destination: Any
Destination Port: 8096, 8989, 7878
Description: Prioritize media streaming
```

---

## 📊 **Monitoring and Alerting**

### **Step 6: Configure Logging**

#### **1. Enable Firewall Logging**
1. **Navigate to**: Security → Firewall
2. **Enable**: Logging for all security rules
3. **Configure**: Log retention (30 days)

#### **2. Set Up Alerting**
1. **Navigate to**: Settings → Notifications
2. **Configure Alerts**:
   - Failed login attempts
   - Unusual traffic patterns
   - Rule violations
   - DDoS attacks

#### **3. Configure Log Forwarding**
1. **Navigate to**: Settings → System
2. **Enable**: Syslog forwarding
3. **Configure**: Send logs to monitoring server

### **Step 7: Performance Monitoring**

#### **1. Enable Traffic Analysis**
1. **Navigate to**: Insights → Traffic Analysis
2. **Enable**: Deep packet inspection
3. **Configure**: Application identification

#### **2. Set Up Performance Monitoring**
1. **Navigate to**: Insights → Performance
2. **Monitor**:
   - CPU usage
   - Memory usage
   - Network throughput
   - Rule hit counts

---

## 🔍 **Troubleshooting**

### **Common UDM Pro Issues**

#### **1. Rule Not Working**
```
Checklist:
□ Verify rule is enabled
□ Check rule order (specific before general)
□ Verify source/destination IPs
□ Check if NAT is interfering
□ Review firewall logs
```

#### **2. Performance Issues**
```
Checklist:
□ Monitor CPU usage in Insights
□ Check memory usage
□ Review rule hit counts
□ Optimize rule order
□ Consider rule consolidation
```

#### **3. Security Alerts**
```
Checklist:
□ Review IPS alerts in Security
□ Check blocked traffic logs
□ Review threat management
□ Update IPS signatures
□ Verify security rule effectiveness
```

### **UDM Pro Debugging Commands**

#### **Check Firewall Status**
```bash
# SSH into UDM Pro
ssh root@192.168.1.1

# Check firewall rules
iptables -L -n -v

# Check NAT rules
iptables -t nat -L -n -v

# Check connection tracking
cat /proc/net/nf_conntrack
```

#### **Check Network Status**
```bash
# Check network interfaces
ip addr show

# Check routing table
ip route show

# Check DNS resolution
nslookup google.com
```

#### **Check System Resources**
```bash
# Check CPU usage
top

# Check memory usage
free -h

# Check disk usage
df -h
```

---

## 🛡️ **Security Hardening**

### **Step 8: Additional Security Measures**

#### **1. Enable Advanced Threat Protection**
1. **Navigate to**: Security → Advanced Threat Protection
2. **Enable**: All protection features
3. **Configure**: Custom threat signatures

#### **2. Configure SSL Inspection**
1. **Navigate to**: Security → SSL Inspection
2. **Enable**: SSL inspection for selected networks
3. **Configure**: Certificate management

#### **3. Set Up Geo-Blocking**
1. **Navigate to**: Security → Firewall
2. **Create Rules**: Block traffic from specific countries
3. **Configure**: Geo-blocking for high-risk regions

#### **4. Enable MAC Filtering**
1. **Navigate to**: Settings → Networks
2. **Configure**: MAC address filtering
3. **Set Up**: Whitelist for trusted devices

---

## 📈 **Performance Optimization**

### **Step 9: Optimize Performance**

#### **1. Rule Optimization**
- **Consolidate Rules**: Combine similar rules
- **Optimize Order**: Place frequently used rules first
- **Use Aliases**: Use IP/port aliases for efficiency
- **Disable Unused Rules**: Remove unnecessary rules

#### **2. Hardware Optimization**
- **Monitor Resources**: Use Insights to monitor performance
- **Load Balancing**: Distribute traffic across interfaces
- **Caching**: Enable connection caching
- **Offloading**: Use hardware offloading when available

#### **3. Network Optimization**
- **Traffic Shaping**: Configure QoS for important traffic
- **Bandwidth Management**: Monitor bandwidth usage
- **Latency Optimization**: Optimize routing paths

---

## 🔮 **Advanced Features**

### **Step 10: Enable Advanced Features**

#### **1. High Availability**
- **Failover Configuration**: Set up primary/backup UDM Pro
- **Load Balancing**: Distribute traffic across multiple devices
- **Synchronization**: Sync configurations between devices

#### **2. Advanced Security**
- **Threat Intelligence**: Integrate with threat intelligence feeds
- **Machine Learning**: Use ML for anomaly detection
- **Behavioral Analysis**: Analyze traffic patterns
- **Automated Response**: Configure automated threat response

#### **3. Integration**
- **SIEM Integration**: Integrate with security information systems
- **API Integration**: Use APIs for automated management
- **Cloud Integration**: Integrate with cloud security services

---

## 📋 **Maintenance Checklist**

### **Monthly Tasks**
- [ ] Review firewall rule effectiveness
- [ ] Update IPS signatures
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

This UDM Pro implementation guide provides enterprise-grade security for your homelab while maintaining accessibility and performance. The configuration follows Ubiquiti best practices and can be adapted to your specific network requirements. 