#!/bin/bash
echo "Sourcing environment variables for Apache"
source /etc/apache2/envvars
echo "Starting Apache2"
exec apache2 -D FOREGROUND
