if status is-interactive
    # -------------------------------------------------------------------------
    # SHUNYA Fish
    # -------------------------------------------------------------------------

    # Suppress the default Fish welcome message.
    set -g fish_greeting ""

    # -------------------------------------------------------------------------
    # SHUNYA session overview
    #
    # Show Fastfetch automatically only in the first Kitty shell after login.
    # $XDG_RUNTIME_DIR is cleared with the user session, so Fastfetch appears
    # again after the next login.
    # -------------------------------------------------------------------------

    if set -q KITTY_WINDOW_ID
        set -l marker "$XDG_RUNTIME_DIR/shunya-fastfetch-shown"

        if not test -e "$marker"
            if type -q fastfetch
                fastfetch
                and touch "$marker"
            end
        end
    end

    # -------------------------------------------------------------------------
    # SHUNYA prompt
    # -------------------------------------------------------------------------

    if type -q starship
        # Collapse previous prompts to the prompt character,
        # keeping terminal history visually clean.
        function starship_transient_prompt_func
            starship module character
        end

        starship init fish | source
        enable_transience
    end
end
