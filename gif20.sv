`timescale 1ns/10ps
// Interface definition
interface g20_if (input Qclock, input BusReset);
  logic request,itsyours;
  logic [47:0] Adr,QmAddr;
  logic [15:0] dataIn,dbus_out,Mdin,mdout;
  logic select_slave,Xend,Xend_mstr;
  modport CLKS(input Qclock,input BusReset);

  modport Mstr(
        input request, output itsyours,
        input QmAddr, input mdout, output Mdin,
        output Xend_mstr
  );

  modport MstrR(
        output request, input itsyours,
        output QmAddr, output mdout, input Mdin,
        input Xend
  );

  modport Slave(
        output Adr, output dataIn, input dbus_out,
        output select_slave, input Xend
  );

  modport SlaveR(
        input Adr, input dataIn, output dbus_out,
        input select_slave, input Xend
  );

endinterface

