<!-- omit in toc -->
# Introduction
Pipenv is a higher-level tool to manage packages with virtual environment, which helps to manage Python environment.


<br />

<!-- omit in toc -->
# Table of Contents
- [Fundamental Concepts](#fundamental-concepts)
  - [1. Pipenv](#1-pipenv)
    - [1.1. Pipfile](#11-pipfile)
    - [1.2. Pipfile.lock](#12-pipfilelock)
  - [2. Python Import](#2-python-import)
    - [2.1. Site-Packages](#21-site-packages)
    - [2.2. pip/pip3](#22-pippip3)
- [Commands](#commands)
  - [1. Install Pipenv](#1-install-pipenv)
  - [2. Install specific python](#2-install-specific-python)
  - [3. Update Pipenv](#3-update-pipenv)
  - [4. Create a Pipfile.lock](#4-create-a-pipfilelock)
  - [5. Activate Pipenv](#5-activate-pipenv)
  - [6. Check Versions of Packages in Pipenv](#6-check-versions-of-packages-in-pipenv)
  - [7. Module: Make the Current Directory into Package](#7-module-make-the-current-directory-into-package)
  - [8. Install the Exact Versions Specified in Pipfile.Lock](#8-install-the-exact-versions-specified-in-pipfilelock)
- [Issue](#issue)
  - [1. Still Can Not Update Version Of Numpy To 1.2.1 In Vm](#1-still-can-not-update-version-of-numpy-to-121-in-vm)
  - [2. ERROR: Pipfile.lock not found! You need to run $ pipenv lock before you can continue in CICD.](#2-error-pipfilelock-not-found-you-need-to-run--pipenv-lock-before-you-can-continue-in-cicd)


<br />

# Fundamental Concepts

## 1. Pipenv 
* automatically creates and manages a virtualenv for your projects
* is both a package and virtual environment management tool that uses the Pipfile and Pipfile.lock files to achieve these goals
  
<br />

### 1.1. Pipfile 
* for people to add or remove packages in virtualenv
  

  ```s
  pipenv install <package>
  pipenv uninstall <package>
  pipenv install --dev <package>
  ```

<br />

### 1.2. Pipfile.lock
* for machines to store detailed environment
* automatically generated; should not be modified users

<br />

## 2. Python Import

### 2.1. [Site-Packages](https://medium.com/@will.wang/%E6%92%A5%E9%96%8B-python-pip-site-packages-%E7%9A%84%E8%97%8D%E8%89%B2%E8%9C%98%E8%9B%9B%E7%B6%B2-90e398bb3785)
* a folder is to store python packages
* each Python version (Minor version) has each site-packages to store packages, examples as below:
  * package_A V3.3.1 and package_A V3.3.2 have the same folder
  * package_A V3.4 and package_A V3.3 have different folders

<br />

### 2.2. pip/pip3
* a python package
* to import packages in site-packages
* see which site-packages is used

  ```s
  pip --version
  ```

<br />

# Commands

## 1. Install Pipenv
> e.g. use miniconda to install python environment

  ```s
  pyenv install miniconda3-4.3.30
  
  pyenv global miniconda3-4.3.30

  pip install pipenv
  ```

## 2. Install specific python

  ```s
  pipenv --two  
  pipenv --three  
  pipenv --python 3  
  pipenv --python 3.6  
  pipenv --python 2.7.14  
  
  ```


<br />

## 3. Update Pipenv
> it wil run pipenv lock then pipenv sync

  ```s
  pipenv update
  ```

<br />

## 4. Create a Pipfile.lock
> create a Pipfile.lock , which declares all dependencies (and sub-dependencies) of your project

  ```s
  pipenv lock
  ```

<br />

## 5. Activate Pipenv

  ```s
  pipenv shell
  ```

<br />

## 6. Check Versions of Packages in Pipenv

  ```s
  # after activating pipenv
  pip freeze
  ```

<br />

## 7. Module: Make the Current Directory into Package
> **setup.py** is required

  ```s
  pipenv install -e .
  ```

* -e: editable
  installs a pointer file in site-packages that automatically adds the location of the project to Python's module search path.

<br />

## 8. Install the Exact Versions Specified in Pipfile.Lock
        
  ```s
  pipenv sync
  ```

<br />

# Issue

## 1. Still Can Not Update Version Of Numpy To 1.2.1 In Vm

<br />

## 2. ERROR: Pipfile.lock not found! You need to run $ pipenv lock before you can continue in CICD.

* Case 1: <br />
  when build a docker image
  1. go to the directory with the Dockerfile
  2. pipenv lock
  3. docker build .....  (in the same directory with the Dockerfile because . (the current directory))

* Case 2: <br />
  Make sure the Gitlab CI/CD yml file is in the root of the repository.