check_config() {
	# path to translations
	if [[ ! -d ${KDEREPO_PATH} ]]; then
		echo "KDEREPO_PATH variable in your configuration file does not point to a directory."
		echo "If needed create the dir by: mkdir \"${KDEREPO_PATH}\""
		exit 1
	fi

	# POSIEVE settings
	if [[ ! -x ${POSIEVE} ]]; then
		echo "Variable of POSIEVE binary is not executable or does not exist."
		exit 1
	fi

	# lang settings
	if [[ -z ${KDE_LANG} ]]; then
		echo "Variable KDE_LANG is empty in your configuration file."
		exit 1
	fi
}

create_initial_repo() {
	pushd ${KDEREPO_PATH} > /dev/null || exit 1

	echo "Creating the repository structure at \"${KDEREPO_PATH}\""

	svn co --depth=empty svn://anonsvn.kde.org/home/kde . || exit 1
	svn up --depth=empty branches branches/stable branches/stable/l10n-kde4 || exit 1
	svn up --depth=empty trunk trunk/l10n-support trunk/l10n-kde4 trunk/l10n-kf5 || exit 1

	# create the lokalize file for summit
	cat <<-EOF > summit.lokalize
[General]
AltDir=./trunk/l10n-support/${KDE_LANG}/summit/messages
BranchDir=./trunk/l10n-support/${KDE_LANG}/summit/messages
LangCode=${KDE_LANG}
PoBaseDir=./trunk/l10n-support/${KDE_LANG}/summit/messages
PotBaseDir=./trunk/l10n-support/templates/summit/messages
ProjectID=kde-messages
TargetLangCode=${KDE_LANG}
EOF

	# create the lokalize file for summit documentation
	cat <<-EOF > documentation-summit.lokalize
[General]
AltDir=./trunk/l10n-support/${KDE_LANG}/summit/docmessages
BranchDir=./trunk/l10n-support/${KDE_LANG}/summit/docmessages
LangCode=${KDE_LANG}
PoBaseDir=./trunk/l10n-support/${KDE_LANG}/summit/docmessages
PotBaseDir=./trunk/l10n-support/templates/summit/docmessages
ProjectID=kde-docmessages
TargetLangCode=${KDE_LANG}
EOF

	popd > /dev/null
}

update_repos() {
	pushd ${KDEREPO_PATH} > /dev/null || exit 1

	echo "Updating the repositories to latest versions"

	svn up branches/stable/l10n-kde4/{scripts,templates,${KDE_LANG}} || exit 1
	svn up trunk/l10n-kde4/{scripts,templates,${KDE_LANG}} || exit 1
	svn up trunk/l10n-support/{pology,scripts,templates,${KDE_LANG}} || exit 1
	svn up trunk/l10n-kf5/{scripts,templates,${KDE_LANG}} || exit 1

	popd > /dev/null
}


# Check where we put the config file
[[ -z ${XDG_CONFIG_HOME} ]] && XDG_CONF="${HOME}/.config/" || XDG_CONF="${XDG_CONFIG_HOME}"

if [[ ! -e "${XDG_CONF}/kde-l10n-scripts.conf" ]]; then
	# config does not exist create initial file and exit as user needs to set it up.
	echo "There is no configuration around, generating new one."
	cat <<-EOF > ${XDG_CONF}/kde-l10n-scripts.conf
# Path to translations.
KDEREPO_PATH="/your/path/to/the/translations/repository/"

# Posieve path, by default we use system binary
POSIEVE=\`which posieve\`

# Translation team (cs, de, ru, ...)
KDE_LANG=""
EOF

	echo "Please set up required variables in:"
	echo "    \"${XDG_CONF}/kde-l10n-scripts.conf\""
	exit 0
fi

. "${XDG_CONF}/kde-l10n-scripts.conf"
check_config

# create initial repo if the KDEREPO_PATH is empty
[ "$(ls -A ${KDEREPO_PATH})" ] || create_initial_repo

update_repos
