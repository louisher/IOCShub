import os
import datetime
from time import perf_counter
import pandas as pd
import paramiko


# fmt: off

def run_command_on_Taco_server(command, TACO_server):
    """
    Connects to a TACO server via SSH and runs a specified command.
    Args:
        command (str): The command to be executed on the TACO server.
        TACO_server (dict): A dictionary containing the server connection details:
            - "hostname" (str): The hostname or IP address of the TACO server.
            - "port" (int): The SSH port number.
            - "user" (str): The username for SSH login.
            - "private_ssh_key_path" (str): The file path to the private SSH key.
            - path_ocp_on_server (str): The path on the Taco server where the optimizations are run
    Returns:
        bool: True if the command was executed successfully, False otherwise.
    Raises:
        Exception: If there is an error connecting to the server or running the command.
    Example:c
        TACO_server = {
            "hostname": "192.168.1.1",
            "port": 22,
            "user": "username",
            "private_ssh_key_path": "/path/to/private/key"
                "path_ocp_on_server": "/path/to/ocp/on/server"
        }
        run_command_on_Taco_server("ls -la", TACO_server)
    """
    # Server connection info
    hostname = TACO_server["hostname"]  # replace with your server's IP
    port = TACO_server["port"]  # SSH port (make sure it's correct)
    username = TACO_server["user"]  # replace with your username
    # Path to your private key file
    private_key_path = TACO_server["private_ssh_key_path"]
    # Initialize the SSH client
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

    try:
        # Connect to the server using the private key
        client.connect(
            hostname, port=port, username=username, key_filename=private_key_path
        )
        print("Connected to server successfully!")
        # Run the provided command
        stdin, stdout, stderr = client.exec_command(command)
        # Print the output in real-time
        for line in iter(stdout.readline, ""):
            print(line, end="")  # Print each line of output

        # Print any errors if there are any
        for line in iter(stderr.readline, ""):
            print("Error:", line, end="")

        # Check for the command's exit status
        exit_status = stdout.channel.recv_exit_status()
        if exit_status != 0:
            print(f"Command failed with exit status {exit_status}")
            return False
        else:
            print("Command executed successfully!")
            return True
    except Exception as e:
        print(f"Failed to connect or run command: {e}")
        return False
    finally:
        # Close the connection
        if client.get_transport():
            client.get_transport().close()
        client.close()
        print("Connection closed.")


def make_ocp_directory_on_TACO_server(TACO_server):
    """
    Creates a directory for the OCP model on the TACO server.
    Args:
        model_name (str): The name of the model for which the directory is to be created.
        TACO_server (dict): A dictionary containing the server connection details.
    Returns:
        None
    """
    path = TACO_server["path_ocp_on_server"]
    command = f"rm -rf {path} ; mkdir -p {path}"
    success = run_command_on_Taco_server(command, TACO_server)
    if not success:
        raise Exception("Failed to create the ocp directory on the Taco server.")
    else:
        print(f"Directory created successfully on TACO server at: {path}")
  

def send_file_to_ocp_folder_on_TACO_server(local_path, TACO_server):
    """
    Sends a file to the TACO server using SCP (Secure Copy Protocol).
    Args:
        path_mop (str): The local path of the file to be sent.
        TACO_server (dict): A dictionary containing the TACO server details with the following keys:
            - 'path_ocp_on_server' (str): The destination path on the TACO server.
            - 'port' (int): The port number for the SCP connection.
            - 'user' (str): The username for the SCP connection.
            - 'hostname' (str): The hostname or IP address of the TACO server.
    Returns:
        None
    """

    path = TACO_server["path_ocp_on_server"]
    result = os.system(f"scp -P {TACO_server['port']} {local_path} {TACO_server['user']}@{TACO_server['hostname']}:{path}")
    if result != 0:
        raise Exception("Failed to send the file to the TACO server.")


def compile_OCP(model_name, TACO_server):
    """
    Compiles and tests an OCP model on a TACO server.
    Parameters:
    model_name (str): The name of the model to be compiled and tested.
    TACO_server (dict): A dictionary containing the server configuration, specifically the path to the OCP on the server.
    The function performs the following steps:
    1. Changes the directory to the path specified in the TACO_server dictionary.
    2. Runs the taco command with the given model_name.
    3. Changes the directory to the model's path.
    4. Executes the test script with specific flags.
    Returns:
    None
    """

    path = TACO_server["path_ocp_on_server"]
    taco_command = TACO_server["taco_command"]

    # Compilation
    command = f"cd {path} && {taco_command} {model_name}"
    success = run_command_on_Taco_server(command, TACO_server)
    if not success:
        raise Exception("Failed to compile the OCP model.")

    # Package creation
    command = f"cd {path} ; make package"
    success = run_command_on_Taco_server(command, TACO_server)
    if not success:
        raise Exception("Failed to make the package of the OCP model.")



def run_OCP(model_name, TACO_server):
    """
    Executes an OCP (Optimal Control Problem) model on a specified TACO server.
    Parameters:
    model_name (str): The name of the model to be executed.
    TACO_server (dict): A dictionary containing server details, including the path to the OCP on the server.
    Returns:
    None
    """

    command = ( f"cd {TACO_server['path_ocp_on_server']}/{model_name} ; ./test.sh -f -w -i10000")
    success = run_command_on_Taco_server(command, TACO_server)
    if not success:
        raise Exception("Failed to solve the OCP.")


def download_results_from_TACO_server(local_path, model_name, TACO_server):
    """
    Downloads results from a TACO server for a given model.
    This function uses the scp command to securely copy the outputsAll.csv and
    OutputNames.txt files from the specified TACO server to the local directory.
    Args:
        model_name (str): The name of the model whose results are to be downloaded.
        TACO_server (str): The address of the TACO server.
        path_Taco (str): The path on the TACO server where the model results are stored.
        port (int): The port number to use for the scp command.
    Returns:
        None
    """
    path = f"{ TACO_server['path_ocp_on_server']}/{model_name}"
    result1 = os.system(f"scp -P {TACO_server['port']} {TACO_server['user']}@{TACO_server['hostname']}:{path}/outputsAll.csv {local_path}/outputsAll.csv")
    if result1 != 0:
        raise Exception("Failed to download outputsAll.csv from the TACO server.")

    result2 = os.system(f"scp -P {TACO_server['port']} {TACO_server['user']}@{TACO_server['hostname']}:{path}/OutputNames.txt {local_path}/OutputNames.txt")
    if result2 != 0:
        raise Exception("Failed to download OutputNames.txt from the TACO server.")


def run_operational_optimization(iteration_directory, path_iteration_mop, model_name, TACO_server):
    """
    Runs the operational optimization for a given model on the TACO server.
    Args:
        mop_file (str): The local path to the MOP file to be sent and optimized on the TACO server.
        TACO_server (dict): A dictionary containing the server connection details.
    Returns:
        tuple: Compilation time and optimization time in seconds.
    """

    # remove existing directory if it exists and create a new one to store mop-file and run the ocp
    make_ocp_directory_on_TACO_server(TACO_server)

    # Send the mop file to the TACO server (Here it is assumed that the mop file is in the current directory)
    send_file_to_ocp_folder_on_TACO_server(path_iteration_mop, TACO_server)

    # Compile the model
    start = perf_counter()
    compile_OCP(model_name, TACO_server)
    end = perf_counter()
    compilation_time = end - start

    # Run the OCP model
    start = perf_counter()
    run_OCP(model_name, TACO_server)
    end = perf_counter()
    optimization_time = end - start

    # Download the results
    download_results_from_TACO_server(iteration_directory, model_name, TACO_server)

    print(f"Compilation time: {compilation_time:.2f} seconds")
    print(f"Optimization time: {optimization_time:.2f} seconds")

    return compilation_time, optimization_time


def read_ocp_result(path_outputsAll, path_OutputNames):
    column_names = pd.read_csv(path_OutputNames, header=None)
    column_names = column_names[0].tolist()
    column_names = ["time"] + column_names  # Assuming your time column is named "time"

    df = pd.read_csv(
        path_outputsAll,
        comment="#",
        skiprows=0,
        sep="\t",
        header=None,
        names=column_names,
    )
    df = df.iloc[1:]
    df = df.astype(float)

    start_date = datetime.datetime(2023, 1, 1)  # Set your desired start date
    df["datetime"] = [
        start_date + datetime.timedelta(seconds=time) for time in df["time"]
    ]
    df["hours"] = [
        datetime.timedelta(seconds=time).total_seconds() / 3600 for time in df["time"]
    ]
    df["days"] = [
        datetime.timedelta(seconds=time).total_seconds() / 86400 for time in df["time"]
    ]

    return df
