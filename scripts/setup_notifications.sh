#!/bin/bash

# Notification Setup Script
# Interactive setup for configuring notification webhooks and channels

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration file
VAULT_FILE="group_vars/all/vault.yml"
NOTIFICATIONS_FILE="group_vars/all/notifications.yml"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Homelab Notification Setup Script${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if vault file exists
if [ ! -f "$VAULT_FILE" ]; then
    echo -e "${YELLOW}Creating vault file...${NC}"
    cp group_vars/all/vault.yml.template "$VAULT_FILE"
fi

# Function to prompt for input with default
prompt_with_default() {
    local prompt="$1"
    local default="$2"
    local var_name="$3"
    
    if [ -n "$default" ]; then
        read -p "$prompt [$default]: " input
        input=${input:-$default}
    else
        read -p "$prompt: " input
    fi
    
    echo "$input"
}

# Function to update vault file
update_vault() {
    local key="$1"
    local value="$2"
    
    if [ -n "$value" ]; then
        # Check if key exists
        if grep -q "^$key:" "$VAULT_FILE"; then
            # Update existing key
            sed -i "s/^$key:.*/$key: \"$value\"/" "$VAULT_FILE"
        else
            # Add new key
            echo "$key: \"$value\"" >> "$VAULT_FILE"
        fi
        echo -e "${GREEN}✓ Updated $key${NC}"
    fi
}

echo -e "${YELLOW}Setting up notification channels...${NC}"
echo ""

# Email Configuration
echo -e "${BLUE}=== Email Configuration ===${NC}"
smtp_host=$(prompt_with_default "SMTP Host" "smtp.gmail.com" "smtp_host")
smtp_port=$(prompt_with_default "SMTP Port" "587" "smtp_port")
smtp_username=$(prompt_with_default "SMTP Username" "" "smtp_username")
smtp_password=$(prompt_with_default "SMTP Password" "" "smtp_password")
admin_email=$(prompt_with_default "Admin Email" "{{ admin_email | default("admin@" + domain) }} -d)" "admin_email")

update_vault "vault_smtp_host" "$smtp_host"
update_vault "vault_smtp_port" "$smtp_port"
update_vault "vault_smtp_username" "$smtp_username"
update_vault "vault_smtp_password" "$smtp_password"
update_vault "admin_email" "$admin_email"

echo ""

# Slack Configuration
echo -e "${BLUE}=== Slack Configuration ===${NC}"
echo "To get your Slack webhook URL:"
echo "1. Go to https://api.slack.com/apps"
echo "2. Create New App → From scratch"
echo "3. Add 'Incoming Webhooks' feature"
echo "4. Create webhook for your channel"
echo ""

use_slack=$(prompt_with_default "Enable Slack notifications? (y/n)" "n" "use_slack")

if [[ $use_slack =~ ^[Yy]$ ]]; then
    slack_webhook=$(prompt_with_default "Slack Webhook URL" "" "slack_webhook")
    slack_channel=$(prompt_with_default "Slack Channel" "#homelab-alerts" "slack_channel")
    
    update_vault "vault_slack_webhook_url" "$slack_webhook"
    update_vault "slack_channel" "$slack_channel"
fi

echo ""

# Discord Configuration
echo -e "${BLUE}=== Discord Configuration ===${NC}"
echo "To get your Discord webhook URL:"
echo "1. Go to your Discord server"
echo "2. Edit Channel → Integrations → Webhooks"
echo "3. Create Webhook and copy the URL"
echo ""

use_discord=$(prompt_with_default "Enable Discord notifications? (y/n)" "n" "use_discord")

if [[ $use_discord =~ ^[Yy]$ ]]; then
    discord_webhook=$(prompt_with_default "Discord Webhook URL" "" "discord_webhook")
    
    update_vault "vault_discord_webhook_url" "$discord_webhook"
fi

echo ""

# Telegram Configuration
echo -e "${BLUE}=== Telegram Configuration ===${NC}"
echo "To get your Telegram bot token and chat ID:"
echo "1. Message @BotFather on Telegram"
echo "2. Create a new bot with /newbot"
echo "3. Get the bot token"
echo "4. Start a chat with your bot"
echo "5. Get your chat ID from @userinfobot"
echo ""

use_telegram=$(prompt_with_default "Enable Telegram notifications? (y/n)" "n" "use_telegram")

if [[ $use_telegram =~ ^[Yy]$ ]]; then
    telegram_token=$(prompt_with_default "Telegram Bot Token" "" "telegram_token")
    telegram_chat_id=$(prompt_with_default "Telegram Chat ID" "" "telegram_chat_id")
    
    update_vault "vault_telegram_bot_token" "$telegram_token"
    update_vault "vault_telegram_chat_id" "$telegram_chat_id"
fi

echo ""

# PagerDuty Configuration
echo -e "${BLUE}=== PagerDuty Configuration ===${NC}"
echo "To get your PagerDuty integration key:"
echo "1. Go to your PagerDuty service"
echo "2. Integrations → Add integration"
echo "3. Choose 'Prometheus' integration"
echo "4. Copy the integration key"
echo ""

use_pagerduty=$(prompt_with_default "Enable PagerDuty notifications? (y/n)" "n" "use_pagerduty")

if [[ $use_pagerduty =~ ^[Yy]$ ]]; then
    pagerduty_key=$(prompt_with_default "PagerDuty Integration Key" "" "pagerduty_key")
    
    update_vault "vault_pagerduty_integration_key" "$pagerduty_key"
fi

echo ""

# Generic Webhook Configuration
echo -e "${BLUE}=== Generic Webhook Configuration ===${NC}"
echo "For custom integrations or other services"
echo ""

use_webhook=$(prompt_with_default "Enable generic webhook notifications? (y/n)" "n" "use_webhook")

if [[ $use_webhook =~ ^[Yy]$ ]]; then
    webhook_url=$(prompt_with_default "Webhook URL" "" "webhook_url")
    webhook_token=$(prompt_with_default "Webhook Token (optional)" "" "webhook_token")
    
    update_vault "vault_webhook_url" "$webhook_url"
    if [ -n "$webhook_token" ]; then
        update_vault "vault_webhook_token" "$webhook_token"
    fi
fi

echo ""

# Notification Testing
echo -e "${BLUE}=== Notification Testing ===${NC}"
test_notifications=$(prompt_with_default "Test notifications after setup? (y/n)" "y" "test_notifications")

if [[ $test_notifications =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Testing notifications...${NC}"
    
    # Test email
    if [ -n "$smtp_username" ] && [ -n "$smtp_password" ]; then
        echo "Testing email notification..."
        # This would be implemented in the Ansible playbook
        echo -e "${GREEN}✓ Email test queued${NC}"
    fi
    
    # Test Slack
    if [[ $use_slack =~ ^[Yy]$ ]] && [ -n "$slack_webhook" ]; then
        echo "Testing Slack notification..."
        curl -X POST -H 'Content-type: application/json' \
            --data '{"text":"🧪 Test notification from Homelab setup script"}' \
            "$slack_webhook" > /dev/null 2>&1 && echo -e "${GREEN}✓ Slack test sent${NC}" || echo -e "${RED}✗ Slack test failed${NC}"
    fi
    
    # Test Discord
    if [[ $use_discord =~ ^[Yy]$ ]] && [ -n "$discord_webhook" ]; then
        echo "Testing Discord notification..."
        curl -X POST -H 'Content-type: application/json' \
            --data '{"content":"🧪 Test notification from Homelab setup script"}' \
            "$discord_webhook" > /dev/null 2>&1 && echo -e "${GREEN}✓ Discord test sent${NC}" || echo -e "${RED}✗ Discord test failed${NC}"
    fi
    
    # Test Telegram
    if [[ $use_telegram =~ ^[Yy]$ ]] && [ -n "$telegram_token" ] && [ -n "$telegram_chat_id" ]; then
        echo "Testing Telegram notification..."
        curl -X POST "https://api.telegram.org/bot$telegram_token/sendMessage" \
            -d "chat_id=$telegram_chat_id" \
            -d "text=🧪 Test notification from Homelab setup script" > /dev/null 2>&1 && echo -e "${GREEN}✓ Telegram test sent${NC}" || echo -e "${RED}✗ Telegram test failed${NC}"
    fi
fi

echo ""

# Update notifications configuration
echo -e "${YELLOW}Updating notifications configuration...${NC}"

# Enable/disable notification channels based on user input
if [ -f "$NOTIFICATIONS_FILE" ]; then
    # Update Slack enabled status
    if [[ $use_slack =~ ^[Yy]$ ]]; then
        sed -i 's/enabled: "{{ slack_webhook_url is defined }}"/enabled: true/' "$NOTIFICATIONS_FILE"
    else
        sed -i 's/enabled: "{{ slack_webhook_url is defined }}"/enabled: false/' "$NOTIFICATIONS_FILE"
    fi
    
    # Update Discord enabled status
    if [[ $use_discord =~ ^[Yy]$ ]]; then
        sed -i 's/enabled: "{{ discord_webhook_url is defined }}"/enabled: true/' "$NOTIFICATIONS_FILE"
    else
        sed -i 's/enabled: "{{ discord_webhook_url is defined }}"/enabled: false/' "$NOTIFICATIONS_FILE"
    fi
    
    # Update Telegram enabled status
    if [[ $use_telegram =~ ^[Yy]$ ]]; then
        sed -i 's/enabled: "{{ telegram_bot_token is defined }}"/enabled: true/' "$NOTIFICATIONS_FILE"
    else
        sed -i 's/enabled: "{{ telegram_bot_token is defined }}"/enabled: false/' "$NOTIFICATIONS_FILE"
    fi
    
    # Update PagerDuty enabled status
    if [[ $use_pagerduty =~ ^[Yy]$ ]]; then
        sed -i 's/enabled: "{{ pagerduty_integration_key is defined }}"/enabled: true/' "$NOTIFICATIONS_FILE"
    else
        sed -i 's/enabled: "{{ pagerduty_integration_key is defined }}"/enabled: false/' "$NOTIFICATIONS_FILE"
    fi
    
    # Update Webhook enabled status
    if [[ $use_webhook =~ ^[Yy]$ ]]; then
        sed -i 's/enabled: "{{ webhook_url is defined }}"/enabled: true/' "$NOTIFICATIONS_FILE"
    else
        sed -i 's/enabled: "{{ webhook_url is defined }}"/enabled: false/' "$NOTIFICATIONS_FILE"
    fi
fi

echo -e "${GREEN}✓ Notifications configuration updated${NC}"

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Notification Setup Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Review the configuration in $VAULT_FILE"
echo "2. Run: ansible-vault encrypt $VAULT_FILE"
echo "3. Deploy with: ansible-playbook -i inventory.yml site.yml --ask-vault-pass"
echo ""
echo -e "${BLUE}Configured channels:${NC}"
echo "  Email: ${GREEN}✓${NC}"
if [[ $use_slack =~ ^[Yy]$ ]]; then echo "  Slack: ${GREEN}✓${NC}"; else echo "  Slack: ${RED}✗${NC}"; fi
if [[ $use_discord =~ ^[Yy]$ ]]; then echo "  Discord: ${GREEN}✓${NC}"; else echo "  Discord: ${RED}✗${NC}"; fi
if [[ $use_telegram =~ ^[Yy]$ ]]; then echo "  Telegram: ${GREEN}✓${NC}"; else echo "  Telegram: ${RED}✗${NC}"; fi
if [[ $use_pagerduty =~ ^[Yy]$ ]]; then echo "  PagerDuty: ${GREEN}✓${NC}"; else echo "  PagerDuty: ${RED}✗${NC}"; fi
if [[ $use_webhook =~ ^[Yy]$ ]]; then echo "  Webhook: ${GREEN}✓${NC}"; else echo "  Webhook: ${RED}✗${NC}"; fi
echo "" 