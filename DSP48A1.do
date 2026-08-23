vlib work
vlog DSP48A1.v DSP48A1_tb.v MUX41.v MUX21.v OPERATOR.v ParamMux.v REG.v REG_BLK.v
vsim -voptargs=+acc work.DSP48A1_tb
add wave *
run -all
#quit -sim