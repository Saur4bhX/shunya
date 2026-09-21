if status is-interactive
    # Suppress Fish's default welcome message.
    set -g fish_greeting ""

    # Show SHUNYA system information only in the first Kitty
    # shell of the current login session.
    if set -q KITTY_WINDOW_ID
        set -l marker "$XDG_RUNTIME_DIR/shunya-fastfetch-shown"

        if not test -e "$marker"
            touch "$marker"

            if type -q fastfetch
                fastfetch
            end
        end
    end

    # SHUNYA prompt
    if type -q starship
        function starship_transient_prompt_func
            starship module character
        end

        starship init fish | source
        enable_transience
    end
end
