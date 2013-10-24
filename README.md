# playflash.sh

A simple shell script for playing on-line videos from the command line. Perfect companion to the [Xombrero](https://opensource.conformal.com/wiki/xombrero) web browser.

## Requirements & Compatibility

* [mplayer](http://www.mplayerhq.hu/)
* [youtube-dl](http://rg3.github.io/youtube-dl/)

Tested on OpenBSD and Linux.

## Installation

Just copy the script somewhere in your `PATH` and make it executable.

## Usage

Pass the url of the video you want to watch as an argument to the script, eg:

    playflash.sh http://www.youtube.com/watch?v=QH2-TGUlwu4

Videos from Vimeo will be downloaded temporarily in $HOME/tmp and played from that location. You can change that path and some other options as well by setting the variables between `## configuration: start` and `## configuration: end` in the script.

## Integration with Xombrero

To integrate it with the Xombrero web browser add the following line in your $HOME/.xombrero.conf file, replacing `/usr/local/bin` with the path of your installation:

    default_script = /usr/local/bin/playflash.sh

Browse to the video page of your choice in Xombrero and press `Alt + R` to play the video.

## License

This script is licensed under the [ISC license](http://opensource.org/licenses/ISC).
