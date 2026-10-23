#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 2 || ! "$1" =~ ^[A-Za-z0-9._-]+$ ]]; then
	echo "Usage: $0 VERSION OUTPUT_DIRECTORY" >&2
	exit 1
fi

repo_dir="$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"
version="$1"
output_dir="$(mkdir -p "$2" && cd "$2" && pwd)"
source_dir="ath11k-firmware/QCN9074/hw1.0/testing/2.15/WLAN.HK.${version}-QCAHKSWPL_SILICONZ-1"
archive_dir="ath11k-firmware-qcn9074-${version}"
archive="${output_dir}/${archive_dir}.tar.zst"
epoch="$(git -C "$repo_dir" show -s --format=%ct HEAD)"
work_dir="$(mktemp -d "${TMPDIR:-/tmp}/package-qcn9074.XXXXXX")"
trap 'rm -rf "$work_dir"' EXIT

git -C "$repo_dir" archive --format=tar --prefix="${archive_dir}/" "HEAD:${source_dir}" |
	tar -xf - -C "$work_dir"
git -C "$repo_dir" show HEAD:ath11k-firmware/LICENSE.md > "$work_dir/$archive_dir/LICENSE.md"
git -C "$repo_dir" show HEAD:Notice.txt > "$work_dir/$archive_dir/Notice.txt"

(
	cd "$work_dir/$archive_dir"
	sha256sum -c SHA256SUMS
)

tar --format=gnu --sort=name --mtime="@${epoch}" --owner=0 --group=0 --numeric-owner \
	-C "$work_dir" -cf - "$archive_dir" | zstd -q -19 -T1 -o "$archive"
(
	cd "$output_dir"
	sha256sum "${archive_dir}.tar.zst" > "${archive_dir}.tar.zst.sha256"
)
echo "$archive"
