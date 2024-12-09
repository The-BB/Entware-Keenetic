#!/bin/sh

[ -x "./staging_dir/host/bin/zstd" ] || \
{ printf '\033[31m%s\033[m' "WARNING: some tools are missing, please run \"make tools\" before re-running this script." && \
  exit 1 ; }

if [ -e .config ]; then
    read -p 'Please note: .config will be rewriten during downloading! Press [Ctrl]+[C] to abort or [Enter] to continue... ' key
fi

for entware_target in ./configs/*.config; do
    [ -e "$entware_target" ] || break
    echo "Getting $entware_target sources..."
    cp "$entware_target" .config
    if ! make -j"$(nproc)" download V=s; then
        echo "$openwrt_target download failed for $entware_target:("
        exit 1
    fi
done
