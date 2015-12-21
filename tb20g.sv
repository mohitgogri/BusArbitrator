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

module tbg20();
  logic Qclock,BusReset;
class Master;
  logic [47:0] QmAddr;
  rand logic [15:0] mdout;
  virtual g20_if intf;
  int target;
  int tpercent;
  int NumWon;
  int InXfr,InXfrNext;
  int NumXfr;
  int targetSlave;
  logic [47:0] targetAddr;
  task CheckGrant;
    begin
      InXfr = InXfrNext;
      if(!InXfr && intf.request===1 && intf.itsyours===1) begin
        NumWon=NumWon+1;
        intf.request=0;
        InXfrNext=1;
      end
      if(InXfr===1) NumXfr=NumXfr+1;
      if(intf.Xend===1 && InXfr) begin
        InXfrNext=0;
      end
    end
  endtask
  task startInterval;
    begin
      NumWon=0;
      InXfr=0;
      InXfrNext=0;
      NumXfr=0;
      intf.request=0;
    end
  endtask
  task pickRandomTarget;
    begin
      target = $urandom_range(12,0);
      randomize(QmAddr) with { QmAddr >= slvs[target].AddrLow && QmAddr <= slvs[target].AddrHigh;};
    end
  endtask
endclass

class Slave;
  rand logic [15:0] dbus_out;
  virtual g20_if intf;
  logic [47:0] AddrLow;
  logic [47:0] AddrHigh;
  task setAddress(input logic [47:0] a,input logic [47:0] b);
    begin
    AddrLow=a;
    AddrHigh=b;
    end
  endtask
  task setSlaveData;
    begin
      intf.dbus_out=dbus_out;
    end
  endtask
  task xfrIt(input Master mst);
    int ix;
    begin
      ix=0;
      while((!intf.select_slave) && ix++ < 500) ##1;
      if(ix >= 500) begin
        die("didn't get slave enable 'select_slave'","");
      end
      repeat($urandom_range(1,5)) begin
        mst.intf.mdout=$random;
        this.intf.dbus_out=$random; 
        ##1 #1;
        if(mst.intf.QmAddr !== this.intf.Adr) begin
          die("Address didn't get to the slave","");
        end
        if(mst.intf.mdout !== this.intf.dataIn) begin
          $display("\n\nmaster %h slave %h",mst.intf.mdout,this.intf.dataIn);
          die("Data to slave didn't work","");
        end
        if(mst.intf.Mdin !== this.intf.dbus_out) begin
          $display("\n\nmaster %h slave %h",mst.intf.Mdin,this.intf.dbus_out);
          die("Data from slave didn't work","");
        end
        mst.NumXfr=mst.NumXfr+1;
      end
      intf.Xend=1;
      ##1 #1 intf.Xend=0;
      mst.InXfr=0;
      mst.InXfrNext=0;
    end
  endtask
endclass

  logic debug=1;
    logic sadness=0;
  int totaldone;
  reg allreq=0;
  Master msts[];
  Slave  slvs[];
  g20_if mif00(Qclock,BusReset);
  Master mc00;
  Slave msc00;
  g20_if mif01(Qclock,BusReset);
  Master mc01;
  Slave msc01;
  g20_if mif02(Qclock,BusReset);
  Master mc02;
  Slave msc02;
  g20_if mif03(Qclock,BusReset);
  Master mc03;
  Slave msc03;
  g20_if mif04(Qclock,BusReset);
  Master mc04;
  Slave msc04;
  g20_if mif05(Qclock,BusReset);
  Master mc05;
  Slave msc05;
  g20_if sif00(Qclock,BusReset);
  Slave sc00;
  g20_if sif01(Qclock,BusReset);
  Slave sc01;
  g20_if sif02(Qclock,BusReset);
  Slave sc02;
  g20_if sif03(Qclock,BusReset);
  Slave sc03;
  g20_if sif04(Qclock,BusReset);
  Slave sc04;
  g20_if sif05(Qclock,BusReset);
  Slave sc05;
  g20_if sif06(Qclock,BusReset);
  Slave sc06;
  int slaveTarget=999;
  int winningMaster=999;

  default clocking cb20 @(posedge(Qclock));
  endclocking

  initial begin
    Qclock=0;
    forever #5 Qclock=~Qclock;
  end

  initial begin
    BusReset=0;
    msts=new[6];
    slvs=new[6+7];
    mc00=new;
    mc00.intf = mif00;
    msts[0]=mc00;
    msc00=new;
    msc00.intf = mif00;
    mc00.tpercent=29;
    msc00.intf.Xend=0;
    slvs[0]=msc00;
    msc00.setAddress(48'h458affff11cd,48'h458affff1281);
    mc01=new;
    mc01.intf = mif01;
    msts[1]=mc01;
    msc01=new;
    msc01.intf = mif01;
    mc01.tpercent=6;
    msc01.intf.Xend=0;
    slvs[1]=msc01;
    msc01.setAddress(48'h2d4bffff63ba,48'h2d4bffff643d);
    mc02=new;
    mc02.intf = mif02;
    msts[2]=mc02;
    msc02=new;
    msc02.intf = mif02;
    mc02.tpercent=13;
    msc02.intf.Xend=0;
    slvs[2]=msc02;
    msc02.setAddress(48'h1df3fffff486,48'h1df3fffff4d0);
    mc03=new;
    mc03.intf = mif03;
    msts[3]=mc03;
    msc03=new;
    msc03.intf = mif03;
    mc03.tpercent=12;
    msc03.intf.Xend=0;
    slvs[3]=msc03;
    msc03.setAddress(48'h263effff1880,48'h263effff193a);
    mc04=new;
    mc04.intf = mif04;
    msts[4]=mc04;
    msc04=new;
    msc04.intf = mif04;
    mc04.tpercent=24;
    msc04.intf.Xend=0;
    slvs[4]=msc04;
    msc04.setAddress(48'h5df8ffffc36e,48'h5df8ffffc3b9);
    mc05=new;
    mc05.intf = mif05;
    msts[5]=mc05;
    msc05=new;
    msc05.intf = mif05;
    mc05.tpercent=16;
    msc05.intf.Xend=0;
    slvs[5]=msc05;
    msc05.setAddress(48'h4b82ffff46c4,48'h4b82ffff475a);
    sc00=new;
    sc00.intf = sif00;
    sc00.setAddress(48'h4d69ffff9a79,48'h4d69ffff9ab4);
    sc00.intf.Xend=0;
    slvs[0+6]=sc00;
    sc01=new;
    sc01.intf = sif01;
    sc01.setAddress(48'h9afffffdb1a,48'h9afffffdb6d);
    sc01.intf.Xend=0;
    slvs[1+6]=sc01;
    sc02=new;
    sc02.intf = sif02;
    sc02.setAddress(48'h521cffffcce9,48'h521cffffcd1c);
    sc02.intf.Xend=0;
    slvs[2+6]=sc02;
    sc03=new;
    sc03.intf = sif03;
    sc03.setAddress(48'h40bffffa47e,48'h40bffffa55b);
    sc03.intf.Xend=0;
    slvs[3+6]=sc03;
    sc04=new;
    sc04.intf = sif04;
    sc04.setAddress(48'h58b3ffff8bb1,48'h58b3ffff8bd7);
    sc04.intf.Xend=0;
    slvs[4+6]=sc04;
    sc05=new;
    sc05.intf = sif05;
    sc05.setAddress(48'hc60ffffd46b,48'hc60ffffd55b);
    sc05.intf.Xend=0;
    slvs[5+6]=sc05;
    sc06=new;
    sc06.intf = sif06;
    sc06.setAddress(48'h272dffffe3dc,48'h272dffffe471);
    sc06.intf.Xend=0;
    slvs[6+6]=sc06;
    cleanInterval;
    #0.1 BusReset=1;
    if(debug) begin
      $dumpfile("tbg20.vcd");
      $dumpvars(9,tbg20);
    end
    ##5 #1 BusReset=0;
    ##2 #1; 
    cleanInterval;
    repeat(100) anInterval(0);
    stats;
    cleanInterval;
    allreq=1;
    repeat(100) anInterval(1);
    stats;
    cleanInterval;
    repeat(100) anInterval2(0);
    stats;
    if(sadness) die("You are off by more than 2 percent","");
    $display("I think it worked");
    $finish;
    ##5000 die("Ran out of time","Out of time");
    $finish;
  end

  g20Arbitrator arb(mif00.CLKS,
    mif00.Mstr,mif00.Slave, // Master 0
    mif01.Mstr,mif01.Slave, // Master 1
    mif02.Mstr,mif02.Slave, // Master 2
    mif03.Mstr,mif03.Slave, // Master 3
    mif04.Mstr,mif04.Slave, // Master 4
    mif05.Mstr,mif05.Slave, // Master 5
    sif00.Slave,	// Slave 0
    sif01.Slave,	// Slave 1
    sif02.Slave,	// Slave 2
    sif03.Slave,	// Slave 3
    sif04.Slave,	// Slave 4
    sif05.Slave,	// Slave 5
    sif06.Slave 	// Slave 6
  );

  task die(input string e0,input string em);
    begin
      $display("\n\n\n=============== Error ==============\n");
      $display(e0);
      $error(em);
      $display("\n\n\n^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n");
      #10 $finish;
    end
  endtask
  task cleanInterval;
    int ix;
    begin
      totaldone=0;
      for(ix=0; ix < 6; ix=ix+1) begin
        msts[ix].startInterval;
      end
    end
  endtask
  task stats;
    int iq;
    real perXfr;
    int totalXfr;
    begin
      totalXfr=0;
      for(iq=0; iq < 6; iq=iq+1) begin
        totalXfr += msts[iq].NumXfr;
      end
      if(totalXfr < 100) begin
        $display("Saw %d transfer cycles",totalXfr);
        die("Too few transfer cycles done","");
      end
      $display("\n%d Transfered",totalXfr);
      $display("\n\tMst\tSim\t\tGoal");
      for(iq=0; iq < 6; iq=iq+1) begin
        perXfr = msts[iq].NumXfr;
        perXfr = perXfr/totalXfr;
        perXfr = perXfr*100.0;
        $display("%d	%5.2f	%d	%5.2f",iq,perXfr,msts[iq].tpercent,perXfr-msts[iq].tpercent);
        if( (perXfr-msts[iq].tpercent)< -2.0) begin
          sadness=1;
          $display("You lost it on %d",iq);
        end
      end
    end
  endtask;
  function logic isBusy(input int sn);
    int ix;
    begin
      if(sn > 998) begin
        for(ix=0; ix < 6; ix=ix+1) begin
          $display("Mstr %d InXfr %b",ix,msts[ix].InXfr);
        end
      end
      for(ix=0; ix < 6; ix=ix+1) begin
//        msts[ix].CheckGrant;
        if(msts[ix].InXfr) begin
          if(sn > 998) $display("Busy Master %d",ix);
          return 1;
        end
      end
      return 0;
    end
  endfunction
  function logic isResp;
    int ix;
    begin
      for(ix=0; ix < 6; ix=ix+1) begin
        if(msts[ix].intf.request===1 && msts[ix].intf.itsyours===1) begin
          slaveTarget=msts[ix].targetSlave;
          winningMaster=ix;
          msts[ix].CheckGrant;
          return 1'b1;
        end
      end
      return 1'b0;
    end
  endfunction
  task setReqs;
    int ix;
    int ixp,ixnp;
    begin
      for(ix=0; ix < 6; ix=ix+1) begin
        ixp=msts[ix].tpercent;
        ixnp=100-ixp;
        if(msts[ix].intf.request===0) begin
          msts[ix].targetSlave=$urandom_range(0,12);
          msts[ix].targetAddr = pickSlaveAddr(msts[ix].targetSlave);
          msts[ix].intf.QmAddr = msts[ix].targetAddr;
        end
        if(allreq) msts[ix].intf.request=1;
        else if(msts[ix].intf.request==0) randcase
          ixp: begin
            msts[ix].intf.request=1;
            msts[ix].targetSlave=$urandom_range(0,12);
            msts[ix].targetAddr = pickSlaveAddr(msts[ix].targetSlave);
            msts[ix].intf.QmAddr = msts[ix].targetAddr;
          end
          ixnp: msts[ix].intf.request=0;
        endcase
      end
    end
  endtask
  task setReqs2;
    int ix;
    int ixp,ixnp;
    begin
      for(ix=0; ix < 6; ix=ix+1) begin
        ixp=msts[ix].tpercent;
        ixnp=100-ixp;
        if(msts[ix].intf.request===0) begin
          msts[ix].targetSlave=$urandom_range(0,12);
          msts[ix].targetAddr = pickSlaveAddr(msts[ix].targetSlave);
          msts[ix].intf.QmAddr = msts[ix].targetAddr;
        end
        if((ix%1)==0) msts[ix].intf.request=1;
        else if(msts[ix].intf.request==0) randcase
          ixp+2: begin
            msts[ix].intf.request=1;
            msts[ix].targetSlave=$urandom_range(0,12);
            msts[ix].targetAddr = pickSlaveAddr(msts[ix].targetSlave);
            msts[ix].intf.QmAddr = msts[ix].targetAddr;
          end
          ixnp-2: msts[ix].intf.request=0;
        endcase
      end
    end
  endtask
  function logic ReqSet;
    int ix;
    begin
      for(ix=0; ix < 6; ix=ix+1) begin
        if(msts[ix].intf.request===1) return 1;
      end
    end
    ReqSet=0;
  endfunction
  function [47:0] pickSlaveAddr(input int sn);
    logic [47:0] wk,diff;
    begin
      diff = slvs[sn].AddrHigh-slvs[sn].AddrLow;
      wk=slvs[sn].AddrLow+$urandom_range(0,diff);
      pickSlaveAddr=wk;
    end
  endfunction
  task anInterval(input int tnum);
    int ix;
    int icnt;
    begin
      ##1 #1;
      ix=0;
      while(isBusy(ix) && ix < 1000) ##1 #1 ix=ix+1;
      if(ix >= 1000) die("Requests not Clearing","Clearing");
      icnt=0;
      ##1 #1;
      while(icnt < 942 || ReqSet() ) begin
        if(icnt < 942 ) setReqs;
        if(ReqSet()) begin
          for( ix=0; (ix < 1000) && (!isResp()); ix=ix+1) ##1 #1;
          if(ix >= 1000) die("Response didn't happen","response");
          icnt=icnt+1;
	  msts[winningMaster].intf.request=0;
          slvs[slaveTarget].xfrIt(msts[winningMaster]);
        end
      end
    end
  endtask
  task anInterval2(input int tnum);
    int ix;
    int icnt;
    begin
      ##1 #1;
      ix=0;
      while(isBusy(ix) && ix < 1000) ##1 #1 ix=ix+1;
      if(ix >= 1000) die("Requests not Clearing","Clearing");
      icnt=0;
      ##1 #1;
      while(icnt < 942 || ReqSet() ) begin
        if(icnt < 942 ) setReqs2;
        if(ReqSet()) begin
          for( ix=0; (ix < 1000) && (!isResp()); ix=ix+1) ##1 #1;
          if(ix >= 1000) die("Response didn't happen","response");
          icnt=icnt+1;
	  msts[winningMaster].intf.request=0;
          slvs[slaveTarget].xfrIt(msts[winningMaster]);
        end
      end
    end
  endtask

endmodule
