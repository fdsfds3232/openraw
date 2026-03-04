from setuptools import setup

setup(
    name="openraw",
    version="0.1.0",
    description="Official Python client for the OpenRaw Agent OS REST API",
    py_modules=["openraw_sdk", "openraw_client"],
    python_requires=">=3.8",
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
)
