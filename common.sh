#!/usr/bin/env bash

# Check where we put the config file
[[ -z ${XDG_CONFIG_HOME} ]] && XDG_CONF="${HOME}/.config/" || XDG_CONF="${XDG_CONFIG_HOME}"

if [[ ! -e "${XDG_CONF}/kde-l10n-scripts.conf" ]]; then
	# config does not exist create initial file and exit as user needs to set it up.
	echo "There is no configuration around, generating new one."
	cat <<-EOF > ${XDG_CONF}/kde-l10n-scripts.conf
# Path to translations.
# We append trunk/l10n-support/cs/summit or other needed.
KDEREPO_PATH="/your/path/to/the/translations/repository/"
# Posieve path, by default we use system binary
POSIEVE=\`which posieve\`
EOF

	echo "Please set up required variables in:"
	echo "    \"${XDG_CONF}/kde-l10n-scripts.conf\""
	exit 0
else
	. "${XDG_CONF}/kde-l10n-scripts.conf"
fi

# TODO: do initial checkout if the KDEREPO_PATH is empty to ease deployment
