# DNS Automation Guide for Homelab Deployment

## Overview

The homelab deployment now includes **automatic DNS record creation** using the Cloudflare API. This eliminates the need to manually create 40+ DNS records and ensures all subdomains are properly configured.

## ✅ What the Setup Asks For

### **Cloudflare Configuration**
The seamless setup script asks for:
- ✅ **Cloudflare Email** (your account email)
- ✅ **Cloudflare API Token** (for automatic DNS management)
- ✅ **DNS Automation** (whether to automatically create all records)

```bash
# During setup, you'll see:
Cloudflare Configuration (Optional but recommended for SSL):
Enable Cloudflare integration? [Y/n]: Y
Cloudflare Email: your-email@domain.com
Cloudflare API Token: your-api-token-here

DNS Automation (Optional):
Automatically create all DNS records using Cloudflare API? [Y/n]: Y
```

## 📋 Complete List of DNS Records

### **Core Infrastructure (5 records)**
```
Type    Name                    Value
A       @                       YOUR_SERVER_IP
A       traefik                 YOUR_SERVER_IP
A       auth                    YOUR_SERVER_IP
A       portainer               YOUR_SERVER_IP
A       dash                    YOUR_SERVER_IP
```

### **Monitoring & Observability (5 records)**
```
Type    Name                    Value
A       grafana                 YOUR_SERVER_IP
A       prometheus              YOUR_SERVER_IP
A       loki                    YOUR_SERVER_IP
A       logs                    YOUR_SERVER_IP
A       alerts                  YOUR_SERVER_IP
```

### **Media Services (8 records)**
```
Type    Name                    Value
A       sonarr                  YOUR_SERVER_IP
A       radarr                  YOUR_SERVER_IP
A       prowlarr                YOUR_SERVER_IP
A       bazarr                  YOUR_SERVER_IP
A       overseerr               YOUR_SERVER_IP
A       jellyfin                YOUR_SERVER_IP
A       tautulli                YOUR_SERVER_IP
A       tv                      YOUR_SERVER_IP
```

### **Development & Storage (7 records)**
```
Type    Name                    Value
A       git                     YOUR_SERVER_IP
A       registry                YOUR_SERVER_IP
A       code                    YOUR_SERVER_IP
A       cloud                   YOUR_SERVER_IP
A       s3                      YOUR_SERVER_IP
A       docs                    YOUR_SERVER_IP
A       photos                  YOUR_SERVER_IP
```

### **Automation & Security (8 records)**
```
Type    Name                    Value
A       hass                    YOUR_SERVER_IP
A       flows                   YOUR_SERVER_IP
A       n8n                     YOUR_SERVER_IP
A       vault                   YOUR_SERVER_IP
A       passwords               YOUR_SERVER_IP
A       vpn                     YOUR_SERVER_IP
A       dns                     YOUR_SERVER_IP
A       proxy                   YOUR_SERVER_IP
```

### **Utilities & Productivity (6 records)**
```
Type    Name                    Value
A       files                   YOUR_SERVER_IP
A       updates                 YOUR_SERVER_IP
A       assets                  YOUR_SERVER_IP
A       bookmarks               YOUR_SERVER_IP
A       reconya                 YOUR_SERVER_IP
A       pezzo                   YOUR_SERVER_IP
```

**Total: 39 DNS records** (plus root domain = 40 total)

## 🔧 DNS Automation Features

### **What Gets Automated**
✅ **Automatic Creation** - Creates all 40 DNS records via Cloudflare API
✅ **Smart Updates** - Updates existing records if they already exist
✅ **Validation** - Checks that records resolve correctly after creation
✅ **Error Handling** - Graceful fallback to manual instructions if automation fails
✅ **Progress Tracking** - Shows real-time progress of record creation

### **Cloudflare API Permissions Required**
```
Zone:Zone:Read
Zone:DNS:Edit
Zone:Zone Settings:Edit
```

### **How to Get Cloudflare API Token**
1. Go to [Cloudflare Dashboard](https://dash.cloudflare.com)
2. Click your profile → **API Tokens**
3. Click **Create Token**
4. Use **Custom Token** template
5. Add these permissions:
   - Zone:Zone:Read
   - Zone:DNS:Edit
   - Zone:Zone Settings:Edit
6. Set **Zone Resources** to **Include: All zones**
7. Click **Continue to summary** → **Create Token**

## 🚀 Usage Options

### **Option 1: Automatic During Setup (Recommended)**
```bash
# Run the seamless setup
./scripts/seamless_setup.sh

# When prompted, enable DNS automation:
Enable Cloudflare integration? [Y/n]: Y
Cloudflare Email: your-email@domain.com
Cloudflare API Token: your-api-token-here
Automatically create all DNS records using Cloudflare API? [Y/n]: Y
```

### **Option 2: Manual After Setup**
```bash
# If you skipped DNS automation during setup, run it later:
python3 scripts/automate_dns_setup.py \
  --domain yourdomain.com \
  --server-ip 192.168.1.100 \
  --cloudflare-email your-email@domain.com \
  --cloudflare-api-token your-api-token-here
```

### **Option 3: Validate Existing Records**
```bash
# Check if your DNS records are set up correctly:
python3 scripts/automate_dns_setup.py \
  --domain yourdomain.com \
  --server-ip 192.168.1.100 \
  --cloudflare-email your-email@domain.com \
  --cloudflare-api-token your-api-token-here \
  --validate-only
```

## 📊 Automation Process

### **Step 1: Authentication**
- Validates Cloudflare API token
- Gets zone ID for your domain
- Checks API permissions

### **Step 2: Record Creation**
- Creates root domain record (@)
- Creates all 39 subdomain records
- Updates existing records if they already exist
- Shows real-time progress

### **Step 3: Validation**
- Waits 30 seconds for DNS propagation
- Tests root domain resolution
- Tests key subdomains (traefik, auth, grafana, dash)
- Reports success/failure for each test

### **Step 4: Summary**
- Shows total records created/updated
- Reports validation results
- Provides fallback instructions if needed

## 🔍 Example Output

```
🚀 Starting DNS Automation for Homelab Deployment
Domain: yourdomain.com
Server IP: 192.168.1.100
Cloudflare Email: your-email@domain.com

✅ Found zone ID: abc123def456

🔧 Creating DNS records for yourdomain.com...
✅ Created DNS record: @.yourdomain.com → 192.168.1.100
✅ Created DNS record: traefik.yourdomain.com → 192.168.1.100
✅ Created DNS record: auth.yourdomain.com → 192.168.1.100
✅ Created DNS record: grafana.yourdomain.com → 192.168.1.100
✅ Created DNS record: dash.yourdomain.com → 192.168.1.100
... (35 more records)

📊 DNS Record Creation Summary:
✅ Successful: 40/40
❌ Failed: 0/40

🎉 All DNS records created successfully!

🔍 Validating DNS records...
⏳ Waiting 30 seconds for DNS propagation...
✅ yourdomain.com resolves correctly
✅ traefik.yourdomain.com resolves correctly
✅ auth.yourdomain.com resolves correctly
✅ grafana.yourdomain.com resolves correctly
✅ dash.yourdomain.com resolves correctly

🎉 DNS validation passed!
🎉 DNS automation completed successfully!
```

## ⚠️ Troubleshooting

### **Common Issues**

#### **1. API Token Permissions**
```
❌ Domain yourdomain.com not found in Cloudflare
```
**Solution:** Ensure your API token has `Zone:Zone:Read` permission

#### **2. Domain Not in Cloudflare**
```
❌ Domain yourdomain.com not found in Cloudflare
```
**Solution:** Add your domain to Cloudflare first

#### **3. DNS Propagation Delay**
```
❌ yourdomain.com does not resolve to 192.168.1.100
```
**Solution:** Wait 5-10 minutes for DNS propagation, then run validation again

#### **4. Network Issues**
```
❌ Error getting zone ID: Connection timeout
```
**Solution:** Check internet connection and Cloudflare API status

### **Manual Fallback**
If automation fails, you can manually create records:

1. **Go to Cloudflare Dashboard**
2. **Select your domain**
3. **Go to DNS → Records**
4. **Add each record manually** using the list above

## 🔒 Security Notes

- **API Token Security**: Store your Cloudflare API token securely
- **Token Permissions**: Use minimal required permissions
- **Token Rotation**: Regularly rotate your API tokens
- **Access Logging**: Monitor API token usage in Cloudflare

## 📈 Benefits

### **Time Savings**
- **Manual Setup**: 30-60 minutes (creating 40 records)
- **Automated Setup**: 2-3 minutes (one command)

### **Error Reduction**
- **No typos** in DNS records
- **Consistent formatting** across all records
- **Automatic validation** after creation

### **Maintenance**
- **Easy updates** if server IP changes
- **Validation tools** for ongoing monitoring
- **Automated cleanup** of old records

## 🎯 Integration with Homelab

The DNS automation integrates seamlessly with the homelab deployment:

1. **Setup Phase**: DNS records created before deployment
2. **Deployment Phase**: Services can immediately use subdomains
3. **Validation Phase**: DNS resolution verified during deployment
4. **Monitoring Phase**: Ongoing DNS health checks

This ensures your homelab services are accessible immediately after deployment without manual DNS configuration. 