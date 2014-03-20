

# Domino on Vagrant

Run IBM Domino on a CentOS 6 instance in Vagrant

## Abstract

This projects aims to deliver an environment to quickly deploy a Domino server on a virtual Linux machine. It does so by using [VirtualBox](https://www.virtualbox.org/) and [Vagrant](https://www.vagrantup.com/) combined with a CentOS 6 image and some custom scripts.

For managing the Domino server the great [Domino on Unix/Linux Start Script](http://www.nashcom.de/nshweb/pages/startscript.htm) by Daniel Nashed is used!

## Reasons

I created this because I want to:

* run my Domino server on Linux instead of Windows
* be able to create separate Domino environments for testing and developing
* not manually install these environments time after time
* give something to the community
* show Domino/XPages developers the power of Vagrant

Next to the above I just think it's fun to do and cool to have :-)

## Usage
[Learn how to use it by reading the tutorial.](TUTORIAL.md)

## Bugs or feature requests

Please use the GitHub issue tracker to let me know what you like to see changed. Of course I'm also open for pull requests!

## Legal stuff

**Please use this software for developing, testing or demonstrations only. These machines are not tuned and secured enough to use in production.**

Copyright 2014 Bram Borggreve

 Licensed under the [Apache License](LICENSE), Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
