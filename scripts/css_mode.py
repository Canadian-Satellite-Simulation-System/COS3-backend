#!/usr/bin/env python3
"""Change the Generic CSS provider's source without restarting NOS3."""
import argparse
import socket
import sys


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("mode", choices=("sim", "hil", "status"))
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=5001)
    args = parser.parse_args()

    try:
        with socket.create_connection((args.host, args.port), timeout=5) as sock:
            sock.settimeout(5)
            sock.sendall((args.mode.upper() + "\n").encode("ascii"))
            reply = sock.recv(256).decode("ascii", errors="replace").strip()
    except OSError as exc:
        parser.exit(1, "CSS mode control connection failed: {}\n".format(exc))

    print(reply)
    return 0 if reply.startswith("OK ") else 1


if __name__ == "__main__":
    sys.exit(main())
