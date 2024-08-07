#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import sys
import logging
import pathlib
import subprocess
import json
from packaging import version

from Utils.github_helper import get_latest_stable_version_from_github
from Utils.log_helper import logger_factory

logger = logger_factory(name="auto_update",level=logging.DEBUG)

class UpdateException(Exception):
    def __init__(self, message="Update Exception"):
        self.message = message
        super().__init__(self.message)
class BuildException(Exception):
    def __init__(self, message="Build Exception"):
        self.message = message
        super().__init__(self.message)      

def local_build_test(build_script_path:str,build_output_path:str,pat_token:str):
    try:
        logger.info('Cleaning...')
        if os.path.exists(build_output_path):
            os.remove(build_output_path)
        command = f'pwsh -ExecutionPolicy Bypass -File "{build_script_path}" -GithubPAT "{pat_token}"'
        logger.info('Compiling...')
        subprocess.run(command, shell=True, check=True)
        if os.path.exists(build_output_path):
            logger.info("PowerShell: Build succeed.")
        else:
            raise BuildException("Build failed.")
    except subprocess.CalledProcessError as e:
        raise BuildException(f"Build failed. Build script error: {e}")
    except Exception as e:
        raise BuildException(f"Build failed. Error: {e}")


def main(json_info_path:str,github_pat_token:str):
    
    with open(json_info_path, 'r', encoding='utf-8') as json_file:
        parsed_dict = json.load(json_file)
    
    jbm_version_old = version.parse(parsed_dict["JetBrainsMono"]["version"])
    jbm_version_new = get_latest_stable_version_from_github(
                        user_name=parsed_dict["JetBrainsMono"]["user_name"],
                        repo_name=parsed_dict["JetBrainsMono"]["repo_name"],
                        timeout=10,
                        defalut_version=parsed_dict["JetBrainsMono"]["defalut_version"],
                        pat_token=github_pat_token
                    )
    nf_version_old = version.parse(parsed_dict["nerd-fonts"]["version"])
    nf_version_new = get_latest_stable_version_from_github(
                        user_name=parsed_dict["nerd-fonts"]["user_name"],
                        repo_name=parsed_dict["nerd-fonts"]["repo_name"],
                        timeout=10,
                        defalut_version=parsed_dict["nerd-fonts"]["defalut_version"],
                        pat_token=github_pat_token
                    )
    if ((jbm_version_new > jbm_version_old) or (nf_version_new > nf_version_old)):
        logger.info("Test build on local.")
        local_build_test(
            build_script_path=parsed_dict["self"]["build_script_path"],
            build_output_path=parsed_dict["self"]["build_output_path"],
            pat_token=github_pat_token)
        self_version = version.parse(parsed_dict['self']['version'])
        self_version = version.parse(f"v{self_version.major}.{self_version.minor+1}")
        parsed_dict['self']['version'] = f"v{self_version}"
        parsed_dict["JetBrainsMono"]["version"] = f"v{jbm_version_new}"
        parsed_dict["nerd-fonts"]["version"] = f"v{nf_version_new}"
        with open(json_info_path, 'w', encoding='utf-8') as json_file:
            json.dump(parsed_dict, json_file)
        logger.info("File updated.")
    else:
        raise UpdateException("The object is the latest version and there is no need to compile and upload it.")

if __name__ == "__main__":
    try:
        if len(sys.argv) != 2:
            print("Usage: python ./auto_update.py <GITHUB_PAT>")
            sys.exit(1)
        script_root = pathlib.Path(__file__).parent.absolute()
        main(json_info_path=f"{script_root}/basicinfo.json",github_pat_token=sys.argv[1])
        print("Success.")
    except BuildException as e:
        logger.warning(f"Build Exception: {e}")
        print(f"Build Exception: {e}")
    except UpdateException as e:
        logger.warning(f"Update Exception: {e}")
        print(f"Update Exception: {e}")
    except Exception as e:
        logger.warning(f"Other Exception: {e}")
        print(f"Other Exception: {e}")