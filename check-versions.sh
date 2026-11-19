#!/bin/sh
set -eu

check_version() {
    name=$1
    executable=$2
    baseline=$3

    if ! command -v "$executable" >/dev/null 2>&1; then
        printf 'BRAK: %s (%s poza PATH)\n' "$name" "$executable" >&2
        return 1
    fi

    if ! output=$("$executable" --version); then
        printf 'BŁĄD: %s --version\n' "$executable" >&2
        return 1
    fi

    # Vagrant prints "Vagrant 2.4.9", VirtualBox prints "7.2.20r175154".
    version=$(printf '%s\n' "$output" | sed -nE '1s/^(Vagrant[[:space:]]+)?([0-9]+\.[0-9]+\.[0-9]+).*$/\2/p')
    if [ -z "$version" ]; then
        printf 'BŁĄD: nierozpoznana wersja %s: %s\n' "$name" "$output" >&2
        return 1
    fi

    if [ "${version%.*}" = "${baseline%.*}" ] &&
        [ "${version##*.}" -ge "${baseline##*.}" ]; then
        printf 'OK: %s %s (profil %s)\n' "$name" "$version" "$baseline"
    else
        printf 'NIEZGODNOŚĆ: %s %s (wymagane %s lub nowsza poprawka w serii %s.x)\n' \
            "$name" "$version" "$baseline" "${baseline%.*}" >&2
        return 1
    fi
}

os=$(uname -s)
case "$os" in
    Darwin|Linux) printf 'Host: %s (%s)\n' "$os" "$(uname -m)" ;;
    *) printf 'Nieobsługiwany system: %s\n' "$os" >&2; exit 2 ;;
esac

status=0
check_version Vagrant vagrant 2.4.9 || status=1
check_version VirtualBox VBoxManage 7.2.20 || status=1
exit "$status"
