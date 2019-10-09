proc arg_or_default {args n def} {
    set result $def
    if {[llength $args]>$n} {
        set result [lindex $args $n]
    }
    return $result
}

proc pin_io_signal_set {args n sig} {
    # invoked for wires with:
    #   {tag value} 0 fred
    # invoked for buses with:
    #   {tag value} n fred[n+base]
    # or
    #   {tag {values}} n fred[n+base]
    set tag      [arg_or_default $args 0 ""]
    set values   [arg_or_default $args 1 {}]
    if {[llength $values]>$n} {
        set_property $tag [lindex $values $n] [get_ports $sig]
    } else {
        set_property $tag [lindex $values 0] [get_ports $sig]
    }
}

proc sig_iter {sig nsigs fn args base_index} {
    # Invoked for wires with:
    #   fred 0 fn fn_args 0
    #     and invokes fn fn_args 0 fred
    # Invoked for buses with:
    #   fred size fn fn_args base
    #     and invokes fn fn_args n fred[n+base]
    if {$nsigs > 1} {
        for {set n 0} {$n < $nsigs} {incr n} {
            set sig_index [expr $n+$base_index]
            set sig_part "${sig}[$sig_index]"
            $fn $args $n $sig_part
        }
    } else {
        $fn $args 0 $sig
    }
}

# pin_desc_entry is  {name size base { {tag values}* } }
proc pin_desc_entry_set_properties {pin_desc_entry} {
    set name  [arg_or_default $pin_desc_entry 0 {}]
    set size  [arg_or_default $pin_desc_entry 1 {}]
    set base  [arg_or_default $pin_desc_entry 2 {}]
    set description [arg_or_default $pin_desc_entry 3 {}]
    foreach d $description {
        puts "Signal $name of size $size from $base description $d"
        sig_iter $name $size pin_io_signal_set $d $base
    }
}

proc pin_desc_set_properties {pin_desc} {
    foreach pde $pin_desc {
        pin_desc_entry_set_properties $pde
    }
}

# XCVU108 clocks (table 1-10)
# SYSCLK1 - 300MHz - G31/F31 - DIFF_SSTL12
# SYSCLK2 - 300MHz - G22/G21 - DIFF_SSTL12
# SYSCLK2 - 300MHz - G22/G21 - DIFF_SSTL12
# CLK_125MHz - 125MHz - BC9/BC8 - LVDS
# FPGA_EMCCLK - ? - AL20 - LVCMOS18
# SYSCTRL_CLK - ? - AL20 - LVCMOS18

