#!/bin/bash

rm -rf .git
rm -rf www
rm -rf ovi
mv qtc_packaging/debian_harmattan debian
rm -rf qtc_packaging
fakeroot dpkg-buildpackage -sa

