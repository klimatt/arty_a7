use marlin::verilog::prelude::*;

#[verilog(src = "../../vsrc/main.sv", name = "main")]
pub struct MainTop;
