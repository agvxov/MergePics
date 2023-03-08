#!/bin/bash

# Merge seqentually named (1.png 2.png) images in $PWD to a single image
# Horizontal or vertical
# Resize to fill empty space

enable -n echo

readonly NORMAL="\33[0m"

readonly BOLD="\33[1m"

readonly RED="\33[31m"
readonly GREEN="\33[32m"
readonly YELLOW="\33[33m"

function usage() {
	echo -e "${BOLD}MergePics [options]  : imageMagick wrapper for concataniting pictures without creating frames${NORMAL}"
	echo -e "	-u        : print this help message"
	echo -e "	-i [path] : specifies input directory name"
	echo -e "	-o [file] : specifies output name"
	echo -e "	-v        : vertical mode (default)"
	echo -e "	-p        : plain (horizontal) mode"
#	echo -e "	-d        : delete input files"
	echo ""
	echo -e "${YELLOW}${BLUE}$$PWD${BLUE} is considered the input folder. Images will be concetanated in alphabetical order.${NORMAL}"
	echo -e "${YELLOW}Input images will be resized.${NORMAL}"
	echo -e "${YELLOW}They will be appended by numerically ascending order of file names.${NORMAL}"
}

IDIR="."
OUTPUT=$(basename $(mktemp -u) | cut -d "." -f 2)".png"
MODE="-append"
#DELETE=""

while getopts "hvpi:o:" O; do
	case $O in
		h) usage && exit ;;
		i) IDIR=$OPTARG ;;
		o) OUTPUT=$OPTARG ;;
		v) MODE="-append" ;;
		p) MODE="+append" ;;
#		d) DELETE="true" ;;
		*) echo -e "${RED}Unrecognized option, exiting...${NORMAL}" && exit 1 ;;
	esac
done

#[ -z "$1" ] && OUTPUT="output"
#OUTPUT="$1"
#OUTPUT="${OUTPUT}.png"
MWIDTH=0
MHIGHT=0
CUT=""

shopt -s nullglob

if [ $MODE == "-append" ]; then
	for i in "$IDIR/"*.jpg "$IDIR/"*.jpeg "$IDIR/"*.png; do
		W=$(identify "$i" | cut -d " " -f 3 | cut -d "x" -f 1) 
		[[ $W -gt $MWIDTH ]] && MWIDTH=$W
	done

	for i in "$IDIR/"*.jpg "$IDIR/"*.jpeg "$IDIR/"*.png; do
		convert "$i" -resize ^${MWIDTH}x0 "${IDIR}/tmp.png"
		mv "${IDIR}/tmp.png" "$i"
	done
else
	for i in "$IDIR/"*.jpg "$IDIR/"*.jpeg "$IDIR/"*.png; do
		H=$(identify "$i" | cut -d " " -f 3 | cut -d "x" -f 2)
		[[ $H -gt $MHIGHT ]] && MHIGHT=$H
	done

	for i in "$IDIR/"*.jpg "$IDIR/"*.jpeg "$IDIR/"*.png; do
		convert "$i" -resize 0x^${MHIGHT} "${IDIR}/tmp.png"
		mv "${IDIR}/tmp.png" "$i"
	done
fi

convert ${MODE} $(find ${IDIR} -maxdepth 1 -type f | sort -n) "$OUTPUT"

#chmod -w "${OUTPUT}"
