"""
conftest.py – pytest configuration for the COSINE test suite.

COSINE is installed as an editable package via pyproject.toml (``pip install -e .``),
so all production imports use the ``COSINE.*`` namespace.  No sys.path manipulation is
required here.
"""
