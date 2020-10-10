.autoimport +

.export handle_port1_user, handle_port2

.include "joytest.inc"

handle_port1_user:
	jsr label_background
	; TODO: read port 1
	; TODO: set POTs to port 2
	; TODO: display port 1
	; TOOD: handle user port
	rts

handle_port2:
	jsr content_background
	; TODO: read port 2
	; TODO: set POTs to port 1
	; TODO: display port 2
	rts
