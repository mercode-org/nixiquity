#!/usr/bin/env python

from distutils.core import setup

setup(
    name='Nixiquity',
    version='0.1',
    description='nixOS merOS Installer',
    author='Maciej Krüger',
    author_email='mkg20001@gmail.com',
    url='https://os.mercode.org',
    packages=['nixiquity', 'nixiquity.glade'],
    package_dir={'nixiquity': 'nixiquity'},
    package_data={'nixiquity': ['glade/*.ui']},
    entry_points={
        'console_scripts': [
            'nixiquity=nixiquity.nixiquity:main',
        ],
    },
)
