
use arty_a7_tests::MainTop;
use marlin::verilator::{VerilatorRuntime, VerilatorRuntimeOptions};
use snafu::Whatever;

#[test]
#[snafu::report]
fn simple_test() -> Result<(), Whatever> {
    let runtime = VerilatorRuntime::new(
        "build".into(),
        &["../../vsrc/main.sv".as_ref()],
        &["../../vsrc".as_ref()],
        [],
        VerilatorRuntimeOptions::default(),
        //true,
    )?;

    let mut main = runtime.create_model::<MainTop>()?;

    //main.clk = 0;
    //main.eval();
    println!("init: {} : {:025b}", main.led, main.cnt);

    for i in 1..10000{
        main.clk = 1;
        main.eval();
        if(main.led != 0){
            println!("{i}: {} {:025b}", main.led, main.cnt);
        }
        main.clk = 0;
        main.eval();

    }
    //assert_eq!(main.medium_output, 0);
    //main.eval();
    //println!("{}", main.medium_output);
    //assert_eq!(main.medium_output, u32::MAX);

    Ok(())
}