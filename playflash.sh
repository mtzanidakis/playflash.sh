#!/bin/sh
#
# playflash.sh: play online videos from a variety of sites from the command line.
#
# Copyright (c) 2013 Manolis Tzanidakis <mtzanidakis@gmail.com>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
# WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
# AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL
# DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR
# PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
# TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.

## configuration: start

# maximum video quality.
# 1080p mp4: 37, 1080p webm: 46,
#  720p mp4: 22,  720p webm: 45,
#  480 webm: 44
_maxq=46

# temporary download directory (for vimeo)
_tmpdir="$HOME/tmp"

# youtube-dl cmd options
_ytopts="--max-quality ${_maxq}"

# mplayer cmd options
_mpopts="-really-quiet -cache 1024"

## configuration: end

## actual script

# exit if requirements are not installed
for _cmd in youtube-dl mplayer; do
	if ! which ${_cmd} >/dev/null 2>&1; then
		echo "error: ${_cmd} is not installed."
		exit 1
	fi
done

# the video url
if [ -z "$1" ]; then
	echo "usage: $(basename $0) [url]"
	exit 0
else
	_vidurl="$1"
fi

# vimeo does not play along with streaming very well. download the video
# to a temporary directory ($_tmpdir) and play that instead.
if echo "${_vidurl}" | grep -q vimeo; then
	_id=$(youtube-dl --get-id "${_vidurl}")
	_title=$(youtube-dl -e "${_vidurl}")
	_tmpvid="${_tmpdir}/${_id}.mp4"

	# send desktop notification if notify-send is installed
	# XXX: add support for other programs maybe
	which notify-send >/dev/null 2>&1 && notify-send -t 5000 \
		"$(basename $0): background video download"       \
		"'${_title}'\n-> ${_tmpvid}\n\nPlease wait."

	# download the video
	youtube-dl ${_ytopts} "${_vidurl}" -o ${_tmpvid} \
		|| rm -f "${_tmpvid}.part"

	# play the video and delete the temp file afterwards
	mplayer ${_mpopts} ${_tmpvid}
	rm -f ${_tmpvid}
else
	# get the video file url and play the video directly
	mplayer ${_mpopts} \
		$(youtube-dl ${_ytopts} -g ${_vidurl})
fi
