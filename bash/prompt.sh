#
# bash/prompt.sh
#

_is_vte_term() {
    if [[ -f /etc/profile.d/vte.sh ]] && [[ -n "$VTE_VERSION" ]]; then
        __vte_prompt_command
    fi
}

_branch_git() {
    git rev-parse --abbrev-ref HEAD 2> /dev/null
}

_branch_svn() {
    svn info 2> /dev/null | grep '^URL:' | \
        grep -Eo '(tags|branches)/[^/]+|trunk' | grep -Eo '[^/]+$' | \
        sed 'N;s/\n/\//'
}

_prompt() {
    GIT_BRANCH=`_branch_git`
    if [ -n "$GIT_BRANCH" ]; then
        echo -e "$txtblu\u$txtrst@$txtgrn\h $txtred\W $txtpur$GIT_BRANCH" \
                "$txtylw\\\$ $txtrst"
        return
    fi

    SVN_BRANCH=`_branch_svn`
    if [ -n "$SVN_BRANCH" ]; then
        echo -e "$txtblu\u$txtrst@$txtgrn\h $txtred\W $txtpur$SVN_BRANCH" \
                "$txtylw\\\$ $txtrst"
        return
    fi

    echo -e "$txtblu\u$txtrst@$txtgrn\h $txtred\W $txtylw\\\$ $txtrst"
}

PROMPT_COMMAND='_is_vte_term; PS1=$(_prompt)'

