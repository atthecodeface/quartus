
proc pin_io_signal {pin io sig {base_index 0}} {
    if {[llength $pin] > 1} {
        for {set n 0} {$n < [llength $pin]} {incr n} {
            set sig_index [expr $n+$base_index]
            set sig_part "${sig}[$sig_index]"
            set_location_assignment PIN_[lindex $pin $n] -to $sig_part
            set_instance_assignment -name IO_STANDARD $io -to $sig_part
            set_instance_assignment -name SLEW_RATE 1               -to $sig_part
            set_instance_assignment -name CURRENT_STRENGTH_NEW 16MA -to $sig_part
        }
    } else {
        set_location_assignment PIN_$pin -to $sig
        set_instance_assignment -name IO_STANDARD $io -to $sig
        set_instance_assignment -name SLEW_RATE 1               -to $sig
        set_instance_assignment -name CURRENT_STRENGTH_NEW 16MA -to $sig
    }
}
proc pin_lvttl_signal {pin sig {base_index 0}} {
    # slew rate is 1 by default; 0 slow, 1 medium, 2 fast???
    # current strength is 16mA by default
    pin_io_signal $pin "3.3-V LVTTL" $sig $base_index
}

proc pin_2_5v_signal {pin sig {base_index 0}} {
    pin_io_signal $pin "2.5 V" $sig $base_index
}

proc io_signal {io tag sig nsig {base_index 0}} {
    if {$nsig > 1} {
        for {set n 0} {$n < $nsig} {incr n} {
            set sig_index [expr $n+$base_index]
            set sig_part "${sig}[$sig_index]"
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

proc diff_sstl_signal {tag sig nsig {base_index 0}} {
    io_signal "DIFFERENTIAL 1.5-V SSTL CLASS I" $tag $sig $nsig $base_index
}

proc sstl_signal {tag sig nsig {base_index 0}} {
    io_signal "SSTL-15 CLASS I" $tag $sig $nsig $base_index
}

proc lvttl_signal {tag sig nsig {base_index 0}} {
    io_signal "3.3-V LVTTL" $tag $sig $nsig $base_index
}

proc inst_assign {name value tag sig nsig {base_index 0}} {
    if {$nsig > 1} {
        for {set n 0} {$n < $nsig} {incr n} {
            set sig_index [expr $n+$base_index]
            set sig_part "${sig}[$sig_index]"
            set_instance_assignment -name $name $value -to $sig_part -tag $tag
        }
    } else {
        set_instance_assignment -name $name $value -to $sig -tag $tag
    }
}

proc term50 {tag sig nsig {base_index 0}} {
    inst_assign INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" $tag $sig $nsig $base_index
    inst_assign OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" $tag $sig $nsig $base_index
}

