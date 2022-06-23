#!/usr/bin/env bash
set -xeuo pipefail

systemctl enable getty@tty1.service

systemctl disable sshd.service
