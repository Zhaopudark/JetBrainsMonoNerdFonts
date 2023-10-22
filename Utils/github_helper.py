import os
import requests
import subprocess
from packaging import version

def get_latest_stable_version(
    user_name:str,
    repo_name:str,
    timeout:int,
    defalut_version:str)->version.Version:
    try:
        url = f"https://api.github.com/repos/{user_name}/{repo_name}/releases/latest"
        response = requests.get(url,timeout=timeout)
        if response.status_code == 200:
            return version.parse(response.json()["tag_name"])
        else:
            return version.parse(defalut_version)
    except:
        return version.parse(defalut_version)
