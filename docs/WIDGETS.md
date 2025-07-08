# Homelab Homepage Widgets: Customization, Extension & Troubleshooting

## Overview
This document explains how to configure, extend, and troubleshoot widgets for your Homelab Homepage dashboard. It covers widget structure, adding new widgets, API key management, automation, and best practices for robust, real-time monitoring.

---

## 1. Widget Configuration Structure
Each widget is defined in `homepage/config/widgets.yml` using the following structure:

```yaml
widget_name:
  label: Friendly Name
  type: service_type
  url: http://service:port
  apiKey: "{{ service_api_key | default('') }}"  # Optional, if required
  config:
    show_status: true
    show_metrics: true
    show_actions: true
    custom_css: true
    error_handling: true
    interval: 60  # Refresh interval in seconds
```

**Key fields:**
- `label`: Display name for the widget
- `type`: Service type (must match the service integration)
- `url`: Endpoint for the service API
- `apiKey`: (Optional) API key, referenced via environment variable
- `config`: Controls widget features and refresh behavior

---

## 2. Adding a New Widget
1. **Identify the service** you want to monitor (see `homepage/config/services.yml` for available services).
2. **Add a new entry** to `widgets.yml` using the standard structure above.
3. **Set the correct `type` and `url`** for the service.
4. **Configure advanced options** in the `config` section (status, metrics, actions, etc.).
5. **If the service requires an API key**, ensure it is referenced as a template variable and set in your environment.
6. **Restart/reload** the homepage dashboard to apply changes.

---

## 3. API Key Management
- **Never hardcode API keys.**
- Store keys in an environment file (e.g., `.env`) or secrets manager.
- Reference keys in widget configs using Jinja-style templates, e.g.:
  ```yaml
  apiKey: "{{ grafana_api_key | default('') }}"
  ```
- Ensure your deployment loads these environment variables.
- Use the provided `auto_generate_widgets.py` and (optionally) an API key check script to validate coverage.

---

## 4. Real-Time Updates & Status Indicators
- Set `interval` in the `config` section to control refresh rate (in seconds).
- Use `show_status: true` to enable color-coded status indicators (green/yellow/red) for service health.
- Widgets will auto-refresh and update their display based on the latest data.

---

## 5. Quick Actions & Error Handling
- Enable `show_actions: true` to provide buttons for common actions (restart, backup, logs, etc.).
- Set `error_handling: true` to ensure widgets gracefully handle API failures or service downtime.
- Use `custom_css: true` to apply enhanced styling and status visuals.

---

## 6. Dynamic Widget Automation
- Use the script `homepage/scripts/auto_generate_widgets.py` to:
  - Scan for services in `services.yml` missing from `widgets.yml`
  - Print YAML stubs for missing widgets (for review and addition)
- This helps keep widget coverage in sync with your actual service stack.

---

## 7. Troubleshooting Common Widget Issues
- **Widget not displaying:**
  - Check for typos in `widgets.yml` and ensure the widget type matches the service.
  - Confirm the service is running and accessible at the specified `url`.
- **API key errors:**
  - Ensure the required environment variable is set and available to the dashboard process.
  - Use the API key check script to identify missing keys.
- **No real-time updates:**
  - Verify the `interval` is set and the service API is responsive.
- **Status indicator always red:**
  - Check the health endpoint and service logs for errors.
- **Widget actions not working:**
  - Ensure the service API supports the requested actions and the widget config enables them.

---

## 8. Example Widget YAML
```yaml
jellyfin_libraries:
  label: Jellyfin Libraries
  type: jellyfin
  url: http://jellyfin:8096
  apiKey: "{{ jellyfin_api_key | default('') }}"
  config:
    show_libraries: true
    show_sessions: true
    show_users: true
    show_status: true
    show_metrics: true
    show_actions: true
    custom_css: true
    error_handling: true
    interval: 60
```

---

## 9. References & Further Reading
- `homepage/config/widgets.yml`: Main widget configuration file
- `homepage/config/services.yml`: Service definitions and integration points
- `homepage/scripts/auto_generate_widgets.py`: Dynamic widget automation script
- `homepage/env.example`: Example environment variable file for API keys
- [Homepage Dashboard Documentation](https://gethomepage.dev/)

For advanced troubleshooting, consult service logs and the homepage dashboard logs. 