#!/bin/bash
# If run as a command it returns the cable name or ""
# If sourced it is verbose and sets the environment variable ALTERA_CABLE_FPGA
# ALTERA_BIN=/altera/quartus/bin
function noecho() { :
}
sourced=1
if [ "$0" = "$BASH_SOURCE" ] ; then sourced=0; fi
verbose="echo"
if [ $sourced = 0 ] ; then verbose="noecho"; fi
$verbose "Starting jtagd (needs sudo permission, does nothing if already running)"
sudo $ALTERA_BIN/jtagd 1>&2
$verbose "Reading cable"
cable_results=`$ALTERA_BIN/jtagconfig`
$verbose $cable_results
ALTERA_CABLE_FPGA=`echo "$cable_results" | awk 'BEGIN {RS=""; FS="\n"}{ has_fpga = 0; for (i = 2; i <= NF; i++) if ( $i ~ /02D120DD/ ) has_fpga=1; len = length($1); $1 = substr($1, 4, len-3); if ( has_fpga == 1) print $1 }'`
if [ $sourced = 0 ] ; then echo $ALTERA_CABLE_FPGA; else export ALTERA_CABLE_FPGA ;$verbose "Set ALTERA_CABLE_FPGA to '$ALTERA_CABLE_FPGA'"; fi;

