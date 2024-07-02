import os
import requests
import subprocess
from packaging import version



def get_latest_stable_version_from_github(
    user_name:str,
    repo_name:str,
    timeout:int,
    defalut_version:str,pat_token=str|None)->version.Version:
    try:
        url = f"https://api.github.com/repos/{user_name}/{repo_name}/releases/latest"
        if pat_token is None:
            headers = None
        else:
            headers = {
            'Authorization': f'token {pat_token}'
            }   
        response = requests.get(url,timeout=timeout,headers=headers)
        if response.status_code == 200:
            return version.parse(response.json()["tag_name"])
        else:
            return version.parse(defalut_version)
    except:
        return version.parse(defalut_version)
