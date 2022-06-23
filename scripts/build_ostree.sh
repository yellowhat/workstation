#!/usr/bin/env bash
# Build OSTree
set -euo pipefail

REPO_DIR=${REPO_DIR:-repo}
export REPO_DIR

# Install
dnf install -y \
    policycoreutils \
    rpm-ostree \
    selinux-policy \
    selinux-policy-targeted

# OSTree
ostree init \
    --repo "$REPO_DIR" \
    --mode archive-z2

rpm-ostree compose tree \
    --repo "$REPO_DIR" \
    --force-nocache \
    main.yaml

ostree summary \
    --repo "$REPO_DIR" \
    --update

rm "${REPO_DIR}/.lock"
