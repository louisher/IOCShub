"""
conftest.py – pytest configuration for the COSINE test suite.

Adds the COSINE package directory and the energy_hub sub-package directory to
sys.path so that test modules can import production code without installing it.
"""

import sys
import os

# Absolute path to the COSINE directory (parent of this tests/ folder)
COSINE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
# Absolute path to energy_hub/ inside COSINE
ENERGY_HUB_DIR = os.path.join(COSINE_DIR, "energy_hub")
# Repository root (needed for k_medoids.py which lives there)
REPO_ROOT = os.path.abspath(os.path.join(COSINE_DIR, ".."))

for path in (COSINE_DIR, ENERGY_HUB_DIR, REPO_ROOT):
    if path not in sys.path:
        sys.path.insert(0, path)
