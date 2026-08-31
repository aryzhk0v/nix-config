# Source this file from your interactive shell to keep lf's final directory.
lfcd() {
    lf_last_dir="$(command lf -print-last-dir "$@")"
    [ -d "$lf_last_dir" ] && cd -- "$lf_last_dir"
    unset lf_last_dir
}
