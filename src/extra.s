.section code

display_extra_screen {
    store_word source_ptr, extra_screen
    store_word destination_ptr, screen
    jsr rl_expand
    store_word source_ptr, extra_colors
    store_word destination_ptr, color_ram
    jsr rl_expand

    set_irq_table extra_irq_table

:   jmp :-    
}

extra_next_type {
    rts
}

extra_previous_type {
    rts
}

.section data

extra_colors {
    rl_encode 10 + 4*40, COLOR_GREY_2
    rl_encode 20, COLOR_GREY_3
    .repeat 9 {
        rl_encode 20, COLOR_GREY_2
        rl_encode 20, COLOR_GREY_3
    }
    rl_encode 10 + 10*40, COLOR_GREY_2
    rl_end
}