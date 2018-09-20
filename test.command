#! /bin/bash

ln -s /opt/X11/include/X11 /usr/local/include/X11
PWD="`dirname \"$0\"`"
cd "${PWD}"
Rscript "run.R"
