#!/bin/bash

while ! test -e 'ec2-init-done.markerfile'
do
    sleep 2
done

echo "Create reached it's end!"

exit