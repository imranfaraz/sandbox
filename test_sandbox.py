import cocotb
from cocotb.triggers import ClockCycles, Timer
from cocotb.clock import Clock


@cocotb.test()
async def test_sandbox(dut):

    clock = Clock(dut.i_clk, 1, units="ns")  # 1 GHz clock
    cocotb.start_soon(clock.start(start_high=False))
    cocotb.start_soon(toggle_async_reset(dut))

    dut.i_reset_n_sync.value = 1
    dut.i_d.value = 0xCC
    await ClockCycles(dut.i_clk, 1)

    dut.i_reset_n_sync.value = 0
    await ClockCycles(dut.i_clk, 1)

    dut.i_reset_n_sync.value = 1
    dut.i_d.value = 0xAA
    await ClockCycles(dut.i_clk, 3)

    dut.i_d.value = 0xFF
    await ClockCycles(dut.i_clk, 3)


async def toggle_async_reset(dut):
    dut.i_reset_n_async.value = 1
    await Timer(0.75, units="ns")
    dut.i_reset_n_async.value = 0
    await Timer(0.5, units="ns")
    dut.i_reset_n_async.value = 1
