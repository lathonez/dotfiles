#!/bin/bash
tail -n1 ../logs/*check* | grep -v failed
