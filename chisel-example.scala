//> using scala "2.13.12"
//> using dep "org.chipsalliance::chisel::6.2.0"
//> using plugin "org.chipsalliance:::chisel-plugin::6.2.0"
//> using options "-unchecked", "-deprecation", "-language:reflectiveCalls", "-feature", "-Xcheckinit", "-Xfatal-warnings", "-Ywarn-dead-code", "-Ywarn-unused", "-Ymacro-annotations"

import chisel3._
// _root_ disambiguates from package chisel3.util.circt if user imports chisel3.util._
import _root_.circt.stage.ChiselStage

class Foo extends Module {
  val a, b, c = IO(Input(Bool()))
  val d, e, f = IO(Input(Bool()))
  val foo, bar = IO(Input(UInt(8.W)))
  val out = IO(Output(UInt(8.W)))

  val myReg = RegInit(0.U(8.W))
  out := myReg

  when(a && b && c) {
    myReg := foo
  }
  when(d && e && f) {
    myReg := bar
  }
}

class Mul extends Module {
  val io = IO(new Bundle {
    val en = Input(Bool())
    val multiplier = Input(UInt(64.W))
    val multiplicand = Input(UInt(64.W))
    val product = Output(UInt(128.W))
  })

  val productReg = RegInit(0.U(128.W))
  val counterReg = RegInit(0.U(6.W))

  when(io.en) {
    when(counterReg < 64.U) {
      when(io.multiplier(counterReg)) {
        productReg := productReg + (io.multiplicand << counterReg)
      }
      counterReg := counterReg + 1.U
    }
  } .otherwise {
    productReg := 0.U
    counterReg := 0.U
  }

  io.product := productReg
}

object Main extends App {
  println(
    ChiselStage.emitSystemVerilog(
      gen = new Mul,
      firtoolOpts = Array("-disable-all-randomization", "-strip-debug-info")
    )
  )
}
