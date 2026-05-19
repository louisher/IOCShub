from pathlib import Path
import json

CONFIG_DIR = Path.home() / ".cosine"
CONFIG_DIR.mkdir(exist_ok=True)

CONFIG_PATH = CONFIG_DIR / "taco_server.json"

DEFAULT_TACO_CONFIG = {
    "_comment": "Edit the values below for your TACO server setup.",

    "user": "your_username",

    "hostname": "login.cluster.com",

    "port": 223,

    "private_ssh_key_path": "~/.ssh/id_rsa",

    "path_ocps_on_server": "/homenvme/{user}/SizeOpt",

    "taco_command": "taco"
}


def load_taco_config():

    # Auto-create template
    if not CONFIG_PATH.exists():

        with open(CONFIG_PATH, "w", encoding="utf-8") as f:
            json.dump(DEFAULT_TACO_CONFIG, f, indent=4)

        raise RuntimeError(
            f"\nCreated template config at:\n"
            f"{CONFIG_PATH}\n\n"
            f"Please edit the file before rerunning."
        )

    with open(CONFIG_PATH, "r", encoding="utf-8") as f:
        config = json.load(f)

    # Expand user path
    config["private_ssh_key_path"] = str(
        Path(config["private_ssh_key_path"]).expanduser()
    )

    return config