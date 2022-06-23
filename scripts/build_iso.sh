#!/usr/bin/env bash
# Build ISO
set -euo pipefail

VERSION=${VERSION:-36}
export VERSION
RELEASE=$(date +'%Y%m%dT%H%m')
export RELEASE
REPO_DIR=${REPO_DIR:-repo}
export REPO_DIR
OUT_DIR=${OUT_DIR:-output}
export OUT_DIR

# Install
dnf install -y rpm-ostree lorax

# Build ISO
lorax \
    --product Fedora \
    --version "$VERSION" \
    --release "$RELEASE" \
    --variant "" \
    --isfinal \
    --source "https://kojipkgs.fedoraproject.org/compose/${VERSION}/latest-Fedora-${VERSION}/compose/Everything/x86_64/os/" \
    --nomacboot \
    --volid "Fedora-ostree-x86_64-${VERSION}" \
    --add-template "${PWD}/lorax-configure-repo.tmpl" \
    --add-template "${PWD}/lorax-embed-repo.tmpl" \
    --add-template-var "ostree_osname=fedora" \
    --add-template-var "ostree_oskey=fedora-${VERSION}-primary" \
    --add-template-var "ostree_contenturl=mirrorlist=https://ostree.fedoraproject.org/mirrorlist" \
    --add-template-var "ostree_install_repo=file://${PWD}/${REPO_DIR}" \
    --add-template-var "ostree_install_ref=desktop" \
    --add-template-var "ostree_update_repo=https://yellowhat.gitlab.io/workstation" \
    --add-template-var "ostree_update_ref=desktop" \
    --logfile lorax.log \
    --tmp "${PWD}/temp" \
    --rootfs-size 8 \
    "$OUT_DIR"
