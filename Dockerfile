FROM ubuntu:bionic

MAINTAINER Saurabh Goyal (https://hub.docker.com/repository/docker/saurabh8585/)

##########
#
# Docker Networking Toolkit
#
#     Official DockerHub: https://hub.docker.com/repository/docker/saurabh8585/networking
#     by @saurabh8585
#
# Ubuntu 18.04 LTS with various networking tools pre-installed, for debugging networks.
#
##########

##########
# Packages included
#
# bash-completion	- to make bash tab completion better
# command-not-found	- when you type a command that doesn't exist, it informs you of which package a command is in
# mtr-tiny		- fast and easy to read realtime traceroutes for both IPv4 and IPv6 (tiny version skips all the GTK bloat)
# dnsutils		- provides tools such as `dig` and `nslookup` for DNS debugging
# net-tools		- basic networking tools such as `ifconfig`, `netstat`, `route`, `arp`
# nmap			- port scanning and other network reconnaissance
# traceroute		- self explanatory. alternative to `mtr`
# netcat		- `nc` tool. highly versatile TCP/UDP/unixsocket client and server
# iproute2		- provides the `ip` and `bridge` tools for advanced network configs
# tcpdump		- similar to wireshark, but CLI based. for inspecting network packets
# iputils-ping		- for the `ping` command. supports both IPv4 and v6 in the same binary, instead of `ping` + `ping6`
# openssh		- server and client. for testing ssh connectivity, and so you may ssh into the container for a better experience
# tmux			- run multiple things in one terminal session, with tabs and split windows
# screen		- similar to tmux, for running things in the background
# vim/nano		- for times when you need a text editor. remember! don't expect files on a container to be persisted. use a volume.

RUN apt-get update -y && \
    apt-get install -y bash-completion command-not-found mtr-tiny dnsutils net-tools && \
    apt-get install -y nmap traceroute netcat iproute2 tcpdump iputils-ping isc-dhcp-client hping3 fping && \
    apt-get install -y openssh-server openssh-client tmux screen vim nano && \
    apt-get install -y apache2 apache2-utils curl && \
    apt-get clean -qy

# More readable bash prompt, with timestamp and colours
# Plus set up SSH, with default root pass of 'ca$hc0w'
SHELL ["/bin/bash","-c"]
RUN echo 'PS1="\[\033[35m\]\t \[\033[32m\]\h\[\033[m\]:\[\033[33;1m\]\w\[\033[m\] # "' >> /root/.bashrc && \
    chsh -s /bin/bash root && \
    mkdir /run/sshd && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo 'root:ca$hc0w' | chpasswd

# Expose SSH port
EXPOSE 22

# Creating Entrypoint file
RUN echo "/usr/sbin/sshd && service apache2 restart && service ssh restart && bash" > /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh

# Entrypoint
CMD /root/entrypoint.sh
