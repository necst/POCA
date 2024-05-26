import setuptools

with open("README.md", "r") as fh:
    long_description = fh.read()

setuptools.setup(
    name="poca",
    version="1.0.0",
    author="Roberto A. Bertolini, Filippo Carloni, Davide Conficconi, Marco Domenico Santambrogio",
    author_email="robertoalessandro.bertolini@mail.polimi.it, filippo.carloni@polimi.it, davide.conficconi@polimi.it, marco.santambrogio@polimi.it",
    description="A Python library for hardware accelerated cryptography",
    long_description=long_description,
    long_description_content_type="text/markdown",
    packages=setuptools.find_packages(),
    package_data={'poca': ['bitstreams/*.bit', 'bitstreams/*.hwh']},
    include_package_data=True,
    install_requires=[
        'pynq>=2.5',
        'numpy>=1.19.5',
    ],
    classifiers=[
        "Programming Language :: Python :: 3",
        "Topic :: Security :: Cryptography",
    ],
    python_requires='>=3.6',
)
