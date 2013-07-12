#!/bin/bash

# $1 Support ticket number (WHL-12345)
# $2 Live Branch
# $3 Modules

if [ "$1" = "" -o "$2" = "" -o "$3" = "" ]
then
	echo "usage: branch WIL-12345 B_WillHill_31_1_1 willhill/cust"
	exit 1
fi

source_tag="S_Support_$1"
branch_tag="B_Support_$1"

echo ""
echo "*** | BRANCH COMMAND |***"
echo ""
echo "!Dont forget to set cvso|cvsd!"
echo ""
echo "cvs rtag -r $2 $source_tag $3; cvs rtag -r $source_tag -b $branch_tag $3; cvs -q upd -r $branch_tag"
echo ""
echo "*************************"
echo ""

