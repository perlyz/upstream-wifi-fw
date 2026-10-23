# Upstream Wifi Firmware
	
Wifi Firmware files for chipsets and platforms supported by Open source Qualcomm Drivers.

The QCN9074 2.15.0.1.r2-00004 firmware is imported from the fixed version
used by LibWrt 25.12-nss. Its version directory contains the source reference
and SHA-256 checksums; existing firmware versions remain available.

To reproduce the QCN9074 release archive from a committed checkout:

```sh
bash scripts/package-qcn9074.sh 2.15.0.1.r2-00004 /path/to/output
```

The archive includes the original binary files, provenance, checksums,
license and notices. Its timestamps are taken from the source commit.
