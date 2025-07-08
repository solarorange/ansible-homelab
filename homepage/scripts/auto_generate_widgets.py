import yaml
import os

SERVICES_YML = os.path.join(os.path.dirname(__file__), '../config/services.yml')
WIDGETS_YML = os.path.join(os.path.dirname(__file__), '../config/widgets.yml')

def load_yaml(path):
    with open(path, 'r') as f:
        return yaml.safe_load(f)

def get_widget_types_from_services(services):
    widget_types = set()
    for group in services:
        for item in group.get('items', []):
            for name, svc in item.items():
                widget = svc.get('widget', {})
                wtype = widget.get('type')
                if wtype:
                    widget_types.add(wtype)
    return widget_types

def get_widget_types_from_widgets(widgets):
    # widgets.yml is a dict of widget_name: {type: ...}
    return set(
        v.get('type') for v in widgets.values() if isinstance(v, dict) and 'type' in v
    )

def generate_stub(wtype):
    return {
        f'{wtype}_auto_stub': {
            'label': f'{wtype.capitalize()} (Auto-generated)',
            'type': wtype,
            'url': f'http://{wtype}:PORT',
            'config': {
                'show_status': True,
                'show_metrics': True,
                'show_actions': True,
                'custom_css': True,
                'error_handling': True,
                'interval': 60
            }
        }
    }

def main():
    services = load_yaml(SERVICES_YML)
    widgets = load_yaml(WIDGETS_YML)
    service_widget_types = get_widget_types_from_services(services)
    widget_types = get_widget_types_from_widgets(widgets)
    missing = service_widget_types - widget_types
    if not missing:
        print('# All widget types from services.yml are present in widgets.yml')
        return
    print('# Missing widget stubs:')
    for wtype in sorted(missing):
        stub = generate_stub(wtype)
        print(yaml.dump(stub, sort_keys=False))

if __name__ == '__main__':
    main() 