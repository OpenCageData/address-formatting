#!/usr/bin/env python3
import yaml
import logging
import os
import sys

logging.basicConfig(level=logging.INFO, format='[%(levelname)s] %(message)s')

with open(os.path.join(
        os.path.dirname(__file__), '..', 'conf', 'countries', 'oneline.yaml'
        ), 'r') as f:
    data = yaml.load(f, Loader=yaml.FullLoader)

ALLOWED_KEYS = {
    'template', 'use_country', 'change_country', 'add_component', 'replace'
}
COMPONENTS = [
    # local house name
    {'house', 'quarter', ',', '/'},
    # address
    {'house_number', 'road', 'house', 'residential', ','},
    # city part
    {'suburb', 'city_district', 'neighbourhood', 'hamlet',
     'village', 'place', 'state_district', 'quarter'},
    # settlement
    {'city', 'town', 'village', 'hamlet', 'postal_city',
     'municipality', 'state_district', 'county', 'state',
     'suburb', 'region', 'island', 'city_district', 'neighbourhood'},
    # region
    {'county', 'state_district', 'state_code', 'county_code',
     'state', 'country', 'region', 'island', 'archipelago',
     'country', 'continent', 'province', 'municipality',
     'postcode'},
]
EMPTY_LINES_IN = ['AQ', 'BT', 'PN', 'TC']

have_warnings = False
have_errors = False
for k, v in data.items():
    if k.startswith('generic'):
        v = {'template': v}
    if not isinstance(v, dict):
        have_errors = True
        logging.error(f'Values are not a dictionary in {k}')
        continue
    if set(v.keys()) - ALLOWED_KEYS:
        have_warnings = True
        logging.warning(f'Extra keys in {k}: {set(v.keys()) - ALLOWED_KEYS}')
    if 'template' not in v:
        if 'use_country' not in v:
            have_errors = True
            logging.error(f'Missing template or use_country in {k}')
        continue
    t = v['template']
    if len(t) != 5:
        have_errors = True
        logging.error(f'Template in {k} should have 5 lines')
        continue
    if t[1]:
        if 'road' not in t[1] or 'house_number' not in t[1]:
            have_warnings = True
            logging.warning(f'Road or house_number missing in line 2 of {k}')
    if 'country' not in t[4]:
        have_errors = True
        logging.error(f'Country is missing in line 5 of {k}')
    if k not in EMPTY_LINES_IN:
        for i in (0, 1, 3, 4):
            if not t[i]:
                have_warnings = True
                logging.warning(f'Line {i+1} of {k} is empty')
    for i in range(5):
        for c in t[i]:
            if c not in COMPONENTS[i]:
                have_warnings = True
                logging.warning(
                    f'Unknown component "{c}" in line {i+1} of {k}')

sys.exit(1 if have_errors or have_warnings else 0)
