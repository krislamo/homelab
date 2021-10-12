#!/bin/bash
[ ! -d "./docs/python" ] && python3 -m venv ./docs/python
. ./docs/python/bin/activate
pip install mkdocs-material==7.3.3
mkdocs serve
deactivate
