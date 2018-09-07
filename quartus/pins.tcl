
proc pin_io_signal {pin io sig} {
    if {[llength $pin] > 1} {
        for {set n 0} {$n < [llength $pin]} {incr n} {
            set sig_part "${sig}[$n]"
            set_location_assignment PIN_[lindex $pin $n] -to $sig_part
            set_instance_assignment -name IO_STANDARD $io -to $sig_part
        }
    } else {
        set_location_assignment PIN_$pin -to $sig
        set_instance_assignment -name IO_STANDARD $io -to $sig
    }
}
proc pin_lvttl_signal {pin sig} {
    pin_io_signal $pin "3.3-V LVTTL" $sig
}

proc io_signal {io tag sig nsig} {
    if {$nsig > 1} {
        for {set n 0} {$n < $nsig} {incr n} {
            set sig_part "${sig}[$n]"
            if {$tag == ""} {
                set_instance_assignment -name IO_STANDARD $io -to $sig_part
            } else {
                set_instance_assignment -name IO_STANDARD $io -to $sig_part -tag $tag
            }
        }
    } else {
        if {$tag == ""} {
            set_instance_assignment -name IO_STANDARD $io -to $sig
        } else {
            set_instance_assignment -name IO_STANDARD $io -to $sig -tag $tag
        }
    }

}

proc diff_sstl_signal {tag sig nsig} {
    io_signal "DIFFERENTIAL 1.5-V SSTL CLASS I" $tag $sig $nsig
}

proc sstl_signal {tag sig nsig} {
    io_signal "SSTL-15 CLASS I" $tag $sig $nsig
}

proc lvttl_signal {tag sig nsig} {
    io_signal "3.3-V LVTTL" $tag $sig $nsig
}

proc inst_assign {name value tag sig nsig} {
    if {$nsig > 1} {
        for {set n 0} {$n < $nsig} {incr n} {
            set sig_part "${sig}[$n]"
            set_instance_assignment -name $name $value -to $sig_part -tag $tag
        }
    } else {
        set_instance_assignment -name $name $value -to $sig -tag $tag
    }
}

proc term50 {tag sig nsig} {
    inst_assign INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" $tag $sig $nsig
    inst_assign OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" $tag $sig $nsig
}

