# fmt: off
import pandas as pd
import datetime
import dash
from dash import dcc, html
from dash.dependencies import Input, Output, State
import plotly.graph_objs as go
import numpy as np
from matplotlib import pyplot as plt
import sys
module_path = r"C:\Workdir\Develop\IOCS"
if module_path not in sys.path:
    sys.path.append(module_path)
import TACO_functions as uf
import helper_functions as hf
from pathlib import Path


path_input_data = Path(r"C:\Workdir\Develop\IOCS\input_data").resolve()
path_results = Path(r"C:\Users\u0148284\OneDrive - KU Leuven\Taco\ResultFiles\IOCS\25250415_ResultsAfterBorefieldFix\OneHouse_TMY\Iteration0").resolve()

writing_time = hf.write_input_profiles(
    path_results, path_input_data)
