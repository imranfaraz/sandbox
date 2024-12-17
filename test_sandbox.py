import cocotb
from cocotb.triggers import ClockCycles
from cocotb.clock import Clock


@cocotb.test()
async def test_sandbox(dut):

    clock = Clock(dut.i_clk, 1, units="ns")  # 1 GHz clock
    cocotb.start_soon(clock.start(start_high=False))

    dut.i_reset_n.value = 0
    await ClockCycles(dut.i_clk, 1)

    dut.i_reset_n.value = 1
    dut.i_d.value = 0xAA
    await ClockCycles(dut.i_clk, 3)

    dut.i_d.value = 0xFF
    await ClockCycles(dut.i_clk, 3)
