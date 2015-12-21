`timescale 1ns/10ps


module g20Arbitrator(g20_if.CLKS clk_blk,
g20_if.Mstr mast0, g20_if.Slave masl0 ,
g20_if.Mstr mast1, g20_if.Slave masl1,
g20_if.Mstr mast2, g20_if.Slave masl2,
g20_if.Mstr mast3, g20_if.Slave masl3,
g20_if.Mstr mast4, g20_if.Slave masl4,
g20_if.Mstr mast5, g20_if.Slave masl5,
g20_if.Slave sl0,
g20_if.Slave sl1,
g20_if.Slave sl2,
g20_if.Slave sl3,
g20_if.Slave sl4,
g20_if.Slave sl5,
g20_if.Slave sl6
);

wire [5:0] request_all , grnt_all;
wire [12:0] select_all;
integer counter,counter0,counter1,counter2,counter3,counter4,counter5;
reg [31:0] counter_delta,counter0_delta,counter1_delta,counter2_delta,counter3_delta,counter4_delta,counter5_delta;
reg [47:0] address_master_slave, data_master_slave, data_slave_master,data_slave_master_delta;
reg [12:0] slave_transfer_done;
reg master_transfer_done;

parameter mst=942;
parameter mst0=273;
parameter mst1=57;
parameter mst2=122;
parameter mst3=113;
parameter mst4=226;
parameter mst5=151;

parameter Idle=0, master0=1, master1=2, master2=3, master3=4, master4=5, master5=6;
reg [2:0] present_state, next_state;

assign slave_transfer_done= {sl6.Xend,sl5.Xend,sl4.Xend,sl3.Xend,sl2.Xend,sl1.Xend,sl0.Xend,
masl5.Xend,masl4.Xend,masl3.Xend,masl2.Xend,masl1.Xend,masl0.Xend};
								
assign request_all= { mast5.request,mast4.request,mast3.request,mast2.request,mast1.request,mast0.request};
assign grnt_all= { mast5.itsyours,mast4.itsyours,mast3.itsyours,mast2.itsyours,mast1.itsyours,mast0.itsyours};
assign select_all={masl5.select_slave,masl4.select_slave,masl3.select_slave,masl2.select_slave,masl1.select_slave,masl0.select_slave,sl6.select_slave,sl5.select_slave,sl4.select_slave,sl3.select_slave,sl2.select_slave,
sl1.select_slave,sl0.select_slave};

always @(posedge clk_blk.Qclock or posedge clk_blk.BusReset)
begin
	if(clk_blk.BusReset)
		begin
			counter_delta<=0;
			counter0_delta<=0;
			counter1_delta<=0;
			counter2_delta<=0;
			counter3_delta<=0;
			counter4_delta<=0;
			counter5_delta<=0;
			//data_slave_master_delta<=0;
			present_state<= Idle;
		end
	else
		begin
		   // data_slave_master_delta<=data_slave_master;
			present_state<=next_state;
			
	if(counter_delta==mst)
		begin
			counter_delta<=0;
			counter0_delta<=0;
                            counter1_delta<=0;
			counter2_delta<=0;
			counter3_delta<=0;
			counter4_delta<=0;
			counter5_delta<=0;
		end
	else
		begin
			counter_delta<=counter;
			counter0_delta<=counter0;
			counter1_delta<=counter1;
			counter2_delta<=counter2;
			counter3_delta<=counter3;
			counter4_delta<=counter4;
			counter5_delta<=counter5;
		end
		end
end
//-------------------RESET STATE--------------//

 
always @(*)
begin
	if(clk_blk.BusReset)
		begin 
			masl0.Adr=48'b0; sl0.Adr=48'b0; masl0.select_slave=1'b0; sl0.select_slave=1'b0;
			masl1.Adr=48'b0; sl1.Adr=48'b0; masl1.select_slave=1'b0; sl1.select_slave=1'b0;
			masl2.Adr=48'b0; sl2.Adr=48'b0; masl2.select_slave=1'b0; sl2.select_slave=1'b0;
			masl3.Adr=48'b0; sl3.Adr=48'b0; masl3.select_slave=1'b0; sl3.select_slave=1'b0;
			masl4.Adr=48'b0; sl4.Adr=48'b0; masl4.select_slave=1'b0; sl4.select_slave=1'b0;
			masl5.Adr=48'b0; sl5.Adr=48'b0; masl5.select_slave=1'b0; sl5.select_slave=1'b0;
                                         sl6.Adr=48'b0;   			 sl6.select_slave=1'b0;
			
			masl0.dataIn=16'b0; sl0.dataIn=16'b0; mast0.Mdin=15'b0;
			masl1.dataIn=16'b0; sl1.dataIn=16'b0; mast1.Mdin=15'b0;
			masl2.dataIn=16'b0; sl2.dataIn=16'b0; mast2.Mdin=15'b0;
			masl3.dataIn=16'b0; sl3.dataIn=16'b0; mast3.Mdin=15'b0;
			masl4.dataIn=16'b0; sl4.dataIn=16'b0; mast4.Mdin=15'b0;
			masl5.dataIn=16'b0; sl5.dataIn=16'b0; mast5.Mdin=15'b0;
                                            sl6.dataIn=16'b0;	
        	next_state=Idle;
        	data_master_slave=0;
        	data_slave_master=0;
		end
		
	else
		begin
			masl0.Adr=48'b0; sl0.Adr=48'b0; masl0.select_slave=1'b0; sl0.select_slave=1'b0;
			masl1.Adr=48'b0; sl1.Adr=48'b0; masl1.select_slave=1'b0; sl1.select_slave=1'b0;
			masl2.Adr=48'b0; sl2.Adr=48'b0; masl2.select_slave=1'b0; sl2.select_slave=1'b0;
			masl3.Adr=48'b0; sl3.Adr=48'b0; masl3.select_slave=1'b0; sl3.select_slave=1'b0;
			masl4.Adr=48'b0; sl4.Adr=48'b0; masl4.select_slave=1'b0; sl4.select_slave=1'b0;
			masl5.Adr=48'b0; sl5.Adr=48'b0; masl5.select_slave=1'b0; sl5.select_slave=1'b0;
                                         sl6.Adr=48'b0;   			 sl6.select_slave=1'b0;
			
			masl0.dataIn=16'b0; sl0.dataIn=16'b0; mast0.Mdin=15'b0;
			masl1.dataIn=16'b0; sl1.dataIn=16'b0; mast1.Mdin=15'b0;
			masl2.dataIn=16'b0; sl2.dataIn=16'b0; mast2.Mdin=15'b0;
			masl3.dataIn=16'b0; sl3.dataIn=16'b0; mast3.Mdin=15'b0;
			masl4.dataIn=16'b0; sl4.dataIn=16'b0; mast4.Mdin=15'b0;
			masl5.dataIn=16'b0; sl5.dataIn=16'b0; mast5.Mdin=15'b0;
                                            sl6.dataIn=16'b0;	
            next_state=Idle;
        	data_master_slave=0;
        	data_slave_master=data_slave_master;                	
	
		if(counter_delta == mst)
			begin
				counter0=0;
				counter1=0;
				counter2=0;
				counter3=0;
				counter4=0;
				counter5=0;
			end
		else 
			begin
				counter0=counter0_delta;
				counter1=counter1_delta;
				counter2=counter2_delta;
				counter3=counter3_delta;
				counter4=counter4_delta;
				counter5=counter5_delta;
				counter=counter_delta;
			end
				
		case(present_state)
		
Idle: begin	      if({mast5.request,mast4.request,mast3.request,mast2.request,mast1.request,mast0.request}==0) begin next_state=Idle; end
			
                        else if (!mast5.request && !mast4.request && !mast3.request && !mast2.request && !mast1.request && mast0.request && counter0_delta < mst0) begin next_state = master0; end
			else if (!mast5.request && !mast4.request && !mast3.request && !mast2.request && mast1.request && mast0.request && counter0_delta < mst0)  begin next_state= master0; end
			else if (!mast5.request && !mast4.request && !mast3.request && mast2.request && !mast1.request && mast0.request && counter0_delta < mst0)  begin next_state= master0; end
			else if (!mast5.request && !mast4.request && mast3.request && !mast2.request && !mast1.request && mast0.request && counter0_delta < mst0)  begin next_state= master0; end		
			else if (!mast5.request && mast4.request && !mast3.request && !mast2.request && !mast1.request && mast0.request && counter0_delta < mst0)  begin next_state= master0; end		
			else if (mast5.request && !mast4.request && !mast3.request && !mast2.request && !mast1.request && mast0.request && counter0_delta < mst0)  begin next_state= master0; end		
                        else if (!mast5.request && !mast4.request && !mast3.request && mast2.request && mast1.request && mast0.request && counter0_delta < mst0)  begin next_state= master0; end
                        else if (!mast5.request && !mast4.request && mast3.request && !mast2.request && mast1.request && mast0.request && counter0_delta < mst0)  begin next_state= master0; end
                        else if (!mast5.request && mast4.request && !mast3.request && !mast2.request && mast1.request && mast0.request && counter0_delta < mst0)  begin next_state= master0; end
                        else if (mast5.request && !mast4.request && !mast3.request && !mast2.request && mast1.request && mast0.request && counter0_delta < mst0)  begin next_state= master0; end
                        else if (!mast5.request && !mast4.request && mast3.request && mast2.request && !mast1.request && mast0.request && counter0_delta < mst0)  begin next_state= master0; end
                        else if (!mast5.request && mast4.request && !mast3.request && mast2.request && !mast1.request && mast0.request && counter0_delta < mst0)  begin next_state= master0; end
                        else if (mast5.request && !mast4.request && !mast3.request && !mast2.request && mast1.request && mast0.request && counter0_delta < mst0)  begin next_state= master0; end
                        else if (!mast5.request && mast4.request && mast3.request && !mast2.request && !mast1.request && mast0.request && counter0_delta < mst0)  begin next_state= master0; end
                        else if (mast5.request && mast4.request && mast3.request && !mast2.request && !mast1.request && mast0.request && counter0_delta < mst0)  begin next_state= master0; end
                        else if (mast5.request && !mast4.request && mast3.request && !mast2.request && !mast1.request && mast0.request && counter0_delta < mst0)  begin next_state= master0; end
                        else if (mast5.request && mast4.request && !mast3.request && !mast2.request && !mast1.request && mast0.request && counter0_delta < mst0)  begin next_state= master0; end
                        else if (!mast5.request && !mast4.request && mast3.request && mast2.request && mast1.request && mast0.request && counter0_delta < mst0)  begin next_state= master0; end
                        else if (mast5.request && mast4.request && !mast3.request && mast2.request && !mast1.request && mast0.request && counter0_delta < mst0)  begin next_state= master0; end
                        else if (mast5.request && mast4.request && !mast3.request && !mast2.request && mast1.request && mast0.request && counter0_delta < mst0)  begin next_state= master0; end
                        else if (mast5.request && !mast4.request && mast3.request && !mast2.request && mast1.request && mast0.request && counter0_delta < mst0)  begin next_state= master0; end
                        else if (!mast5.request && !mast4.request && !mast3.request && !mast2.request && !mast1.request && mast0.request && counter0_delta == mst0)  begin next_state= master0; end
                        else if (mast5.request && mast4.request && mast3.request && mast2.request && mast1.request && mast0.request && counter0_delta < mst0)  begin next_state= master0; end
                        else if (mast5.request && !mast4.request && mast3.request && mast2.request && !mast1.request && mast0.request && counter0_delta < mst0)  begin next_state= master0; end
                        else if (!mast5.request && mast4.request && !mast3.request && !mast2.request && !mast1.request && mast0.request && counter0_delta == mst0 && counter4_delta==mst4)  begin next_state= master0; end 
                        else if (mast5.request && !mast4.request && mast3.request && mast2.request && mast1.request && mast0.request && counter0_delta < mst0)  begin next_state= master0; end
                        else if (!mast5.request && !mast4.request && !mast3.request && mast2.request && !mast1.request && mast0.request && counter0_delta == mst0 && counter2_delta==mst2)  begin next_state= master0; end
                        else if (mast5.request && mast4.request && mast3.request && !mast2.request && mast1.request && mast0.request && counter0_delta < mst0)  begin next_state= master0; end
                        else if (mast5.request && !mast4.request && !mast3.request && mast2.request && !mast1.request && mast0.request && counter0_delta == mst0 && counter2_delta==mst2 && counter5_delta==mst5)  begin next_state= master0; end
                        else if (!mast5.request && mast4.request && !mast3.request && mast2.request && !mast1.request && mast0.request && counter0_delta == mst0 && counter2_delta==mst2 && counter4_delta==mst4)  begin next_state= master0; end
                        else if (!mast5.request && !mast4.request && !mast3.request && mast2.request && mast1.request && mast0.request && counter0_delta == mst0 &&
                        counter2_delta==mst2 && counter1_delta==mst1)  begin next_state= master0; end
                         else if (!mast5.request && mast4.request && !mast3.request && mast2.request && mast1.request && mast0.request && counter0_delta == mst0 &&
                        counter2_delta==mst2 && counter1_delta==mst1 && counter4_delta==mst4)  begin next_state= master0; end
                        else if (!mast5.request && mast4.request && !mast3.request && !mast2.request && mast1.request && mast0.request && counter0_delta == mst0  && counter1_delta==mst1 && counter4_delta==mst4)  begin next_state= master0; end
                        else if (mast5.request && !mast4.request && !mast3.request && !mast2.request && mast1.request && mast0.request && counter0_delta == mst0  && counter1_delta==mst1 && counter5_delta==mst5)  begin next_state= master0; end
                        else if (mast5.request && mast4.request && !mast3.request && !mast2.request && mast1.request && mast0.request && counter4_delta == mst4 && counter5_delta == mst5 && counter1_delta == mst1 && counter0_delta == mst0 )  begin next_state= master0; end
                        
                        else if (!mast5.request && mast4.request && !mast3.request && !mast2.request && !mast1.request && !mast0.request && counter4_delta < mst4)  begin next_state= master4; end
                        else if (!mast5.request && mast4.request && !mast3.request && !mast2.request && mast1.request && !mast0.request && counter4_delta < mst4)  begin next_state= master4; end
                        else if (!mast5.request && mast4.request && !mast3.request && mast2.request && !mast1.request && !mast0.request && counter4_delta < mst4)  begin next_state= master4; end
                        else if (!mast5.request && mast4.request && mast3.request && !mast2.request && !mast1.request && !mast0.request && counter4_delta < mst4)  begin next_state= master4; end
                        else if (mast5.request && mast4.request && !mast3.request && !mast2.request && !mast1.request && !mast0.request && counter4_delta < mst4)  begin next_state= master4; end
                        else if (!mast5.request && mast4.request && !mast3.request && mast2.request && mast1.request && !mast0.request && counter4_delta < mst4)  begin next_state= master4; end
                        else if (!mast5.request && mast4.request && mast3.request && !mast2.request && mast1.request && !mast0.request && counter4_delta < mst4)  begin next_state= master4; end
                        else if (mast5.request && mast4.request && !mast3.request && !mast2.request && mast1.request && !mast0.request && counter4_delta < mst4)  begin next_state= master4; end
                        else if (mast5.request && mast4.request && mast3.request && !mast2.request && !mast1.request && !mast0.request && counter4_delta < mst4)  begin next_state= master4; end
                        else if (mast5.request && mast4.request && !mast3.request && mast2.request && !mast1.request && !mast0.request && counter4_delta < mst4)  begin next_state= master4; end
                        else if (!mast5.request && mast4.request && mast3.request && mast2.request && mast1.request && !mast0.request && counter4_delta < mst4)  begin next_state= master4; end
                        else if (!mast5.request && mast4.request && !mast3.request && !mast2.request && !mast1.request && mast0.request && counter4_delta < mst4)  begin next_state= master4; end
                        else if (!mast5.request && mast4.request && !mast3.request && !mast2.request && !mast1.request && !mast0.request && counter4_delta == mst4)  begin next_state= master4; end
                        else if (mast5.request && mast4.request && !mast3.request && !mast2.request && !mast1.request && mast0.request && counter4_delta < mst4)  begin next_state= master4; end
                        else if (!mast5.request && mast4.request && !mast3.request && !mast2.request && mast1.request && mast0.request && counter4_delta < mst4)  begin next_state= master4; end
                        else if (!mast5.request && mast4.request && mast3.request && mast2.request && mast1.request && mast0.request && counter4_delta < mst4)  begin next_state= master4; end
                        else if (mast5.request && mast4.request && !mast3.request && !mast2.request && !mast1.request && !mast0.request && counter4_delta == mst4 && counter5_delta == mst5 )  begin next_state= master4; end
                        else if (mast5.request && mast4.request && mast3.request && mast2.request && mast1.request && mast0.request && counter4_delta < mst4)  begin next_state= master4; end
                        else if (!mast5.request && mast4.request && !mast3.request && mast2.request && !mast1.request && mast0.request && counter4_delta < mst4)  begin next_state= master4; end
                        else if (mast5.request && mast4.request && !mast3.request && mast2.request && !mast1.request && mast0.request && counter4_delta < mst4)  begin next_state= master4; end
                        else if (mast5.request && mast4.request && mast3.request && !mast2.request && !mast1.request && mast0.request && counter4_delta < mst4)  begin next_state= master4; end
                        else if (!mast5.request && mast4.request && mast3.request && !mast2.request && !mast1.request && mast0.request && counter4_delta < mst4)  begin next_state= master4; end
                        else if (mast5.request && mast4.request && !mast3.request && mast2.request && !mast1.request && !mast0.request && counter4_delta == mst4 && counter5_delta == mst5 && counter2_delta == mst2 )  begin next_state= master4; end
                        else if (!mast5.request && mast4.request && !mast3.request && mast2.request && mast1.request && mast0.request && counter4_delta < mst4)  begin next_state= master4; end
                        else if (mast5.request && mast4.request && !mast3.request && mast2.request && mast1.request && mast0.request && counter4_delta < mst4)  begin next_state= master4; end
                        else if (!mast5.request && mast4.request && !mast3.request && !mast2.request && mast1.request && !mast0.request && counter4_delta== mst4 && counter1_delta== mst1)  begin next_state= master4; end
                        else if (mast5.request && mast4.request && !mast3.request && !mast2.request && mast1.request && mast0.request && counter4_delta < mst4)  begin next_state= master4; end
                        else if (!mast5.request && mast4.request && mast3.request && !mast2.request && mast1.request && mast0.request && counter4_delta < mst4)  begin next_state= master4; end
                        else if (mast5.request && mast4.request && !mast3.request && !mast2.request && mast1.request && !mast0.request && counter4_delta== mst4 && counter1_delta== mst1 && counter5_delta== mst5)  begin next_state= master4; end
                        else if (!mast5.request && mast4.request && mast3.request && mast2.request && !mast1.request && mast0.request && counter4_delta < mst4)  begin next_state= master4; end
                       
                        
                        else if (mast5.request && !mast4.request && !mast3.request && !mast2.request && !mast1.request && !mast0.request && counter5_delta < mst5)  begin next_state= master5; end
                        else if (mast5.request && !mast4.request && !mast3.request && !mast2.request && mast1.request && !mast0.request && counter5_delta < mst5)  begin next_state= master5; end
                        else if (mast5.request && !mast4.request && !mast3.request && mast2.request && !mast1.request && !mast0.request && counter5_delta < mst5)  begin next_state= master5; end
                        else if (mast5.request && !mast4.request && mast3.request && !mast2.request && !mast1.request && !mast0.request && counter5_delta < mst5)  begin next_state= master5; end
                        else if (mast5.request && !mast4.request && !mast3.request && mast2.request && mast1.request && !mast0.request && counter5_delta < mst5)  begin next_state= master5; end
                        else if (mast5.request && !mast4.request && mast3.request && !mast2.request && mast1.request && !mast0.request && counter5_delta < mst5)  begin next_state= master5; end
                        else if (mast5.request && !mast4.request && mast3.request && mast2.request && !mast1.request && !mast0.request && counter5_delta < mst5)  begin next_state= master5; end
                        else if (mast5.request && !mast4.request && mast3.request && mast2.request && mast1.request && !mast0.request && counter5_delta < mst5)  begin next_state= master5; end
                        else if (mast5.request && !mast4.request && !mast3.request && !mast2.request && !mast1.request && !mast0.request && counter5_delta == mst5)  begin next_state= master5; end
                        else if (mast5.request && !mast4.request && !mast3.request && mast2.request && mast1.request && mast0.request && counter5_delta < mst5)  begin next_state= master5; end
                        else if (mast5.request && !mast4.request && mast3.request && mast2.request && !mast1.request && mast0.request && counter5_delta < mst5)  begin next_state= master5; end
                        else if (mast5.request && !mast4.request && !mast3.request && mast2.request && !mast1.request && !mast0.request && counter5_delta == mst5 && counter2_delta == mst2)  begin next_state= master5; end
                        else if (mast5.request && !mast4.request && !mast3.request && !mast2.request && !mast1.request && mast0.request && counter5_delta < mst5)  begin next_state= master5; end
                        else if (mast5.request && !mast4.request && !mast3.request && !mast2.request && !mast1.request && mast0.request && counter5_delta == mst5 && counter0_delta == mst0)  begin next_state= master5; end
                        else if (mast5.request && mast4.request && !mast3.request && !mast2.request && mast1.request && !mast0.request && counter5_delta < mst5)  begin next_state= master5; end
                        else if (mast5.request && mast4.request && !mast3.request && !mast2.request && !mast1.request && !mast0.request && counter5_delta < mst5)  begin next_state= master5; end
                        else if (mast5.request && !mast4.request && mast3.request && !mast2.request && mast1.request && mast0.request && counter5_delta < mst5)  begin next_state= master5; end
                        else if (mast5.request && mast4.request && mast3.request && !mast2.request && !mast1.request && !mast0.request && counter5_delta < mst5)  begin next_state= master5; end
                        else if (mast5.request && mast4.request && !mast3.request && !mast2.request && !mast1.request && mast0.request && counter5_delta < mst5)  begin next_state= master5; end
                        else if (mast5.request && mast4.request && mast3.request && mast2.request && !mast1.request && !mast0.request && counter5_delta < mst5)  begin next_state= master5; end
                        else if (mast5.request && !mast4.request && !mast3.request && mast2.request && !mast1.request && mast0.request && counter5_delta < mst5)  begin next_state= master5; end
                        else if (mast5.request && mast4.request && mast3.request && mast2.request && mast1.request && mast0.request && counter5_delta < mst5)  begin next_state= master5; end
                        else if (mast5.request && mast4.request && !mast3.request && !mast2.request && !mast1.request && mast0.request && counter5_delta < mst5)  begin next_state= master5; end
                        else if (mast5.request && mast4.request && !mast3.request && mast2.request && !mast1.request && !mast0.request && counter5_delta < mst5)  begin next_state= master5; end
                        else if (mast5.request && mast4.request && !mast3.request && !mast2.request && !mast1.request && mast0.request && counter5_delta == mst5 && counter0_delta == mst0 && counter4_delta == mst4)  begin next_state= master5; end
                        else if (mast5.request && mast4.request && !mast3.request && mast2.request && !mast1.request && mast0.request && counter5_delta < mst5)  begin next_state= master5; end
                        else if (mast5.request && mast4.request && mast3.request && mast2.request && !mast1.request && mast0.request && counter5_delta < mst5)  begin next_state= master5; end
                        else if (mast5.request && !mast4.request && !mast3.request && !mast2.request && mast1.request && mast0.request && counter5_delta < mst5)  begin next_state= master5; end
                        else if (mast5.request && mast4.request && !mast3.request && mast2.request && mast1.request && !mast0.request && counter5_delta < mst5)  begin next_state= master5; end
                        else if (mast5.request && !mast4.request && mast3.request && !mast2.request && !mast1.request && mast0.request && counter5_delta < mst5)  begin next_state= master5; end
                        else if (mast5.request && !mast4.request && !mast3.request && !mast2.request && mast1.request && !mast0.request && counter5_delta == mst5 && counter1_delta == mst1)  begin next_state= master5; end
                        else if (mast5.request && mast4.request && !mast3.request && !mast2.request && mast1.request && mast0.request && counter5_delta < mst5)  begin next_state= master5; end
                    
                         
                        else if (!mast5.request && !mast4.request && !mast3.request && mast2.request && !mast1.request && !mast0.request && counter2_delta < mst2)  begin next_state= master2; end
                        else if (!mast5.request && !mast4.request && !mast3.request && mast2.request && mast1.request && !mast0.request && counter2_delta < mst2)  begin next_state= master2; end
                        else if (!mast5.request && !mast4.request && mast3.request && mast2.request && !mast1.request && !mast0.request && counter2_delta < mst2)  begin next_state= master2; end
                        else if (!mast5.request && !mast4.request && mast3.request && mast2.request && mast1.request && !mast0.request && counter2_delta < mst2)  begin next_state= master2; end
                        else if (!mast5.request && !mast4.request && !mast3.request && mast2.request && !mast1.request && !mast0.request && counter2_delta ==mst2)  begin next_state= master2; end
                        else if (mast5.request && mast4.request && !mast3.request && mast2.request && mast1.request && !mast0.request && counter2_delta < mst2)  begin next_state= master2; end
                        else if (mast5.request && mast4.request && mast3.request && mast2.request && mast1.request && !mast0.request && counter2_delta < mst2)  begin next_state= master2; end
                        else if (!mast5.request && !mast4.request && !mast3.request && mast2.request && !mast1.request && mast0.request && counter2_delta < mst2)  begin next_state= master2; end
                        else if (mast5.request && mast4.request && !mast3.request && mast2.request && !mast1.request && mast0.request && counter2_delta < mst2)  begin next_state= master2; end
                        else if (!mast5.request && !mast4.request && mast3.request && mast2.request && !mast1.request && mast0.request && counter2_delta < mst2)  begin next_state= master2; end
                        else if (mast5.request && !mast4.request && !mast3.request && mast2.request && !mast1.request && !mast0.request && counter2_delta < mst2)  begin next_state= master2; end
                        else if (!mast5.request && !mast4.request && mast3.request && mast2.request && mast1.request && mast0.request && counter2_delta < mst2)  begin next_state= master2; end
                        else if (mast5.request && !mast4.request && !mast3.request && mast2.request && !mast1.request && mast0.request && counter2_delta < mst2)  begin next_state= master2; end
                        else if (!mast5.request && mast4.request && mast3.request && mast2.request && !mast1.request && !mast0.request && counter2_delta < mst2)  begin next_state= master2; end
                        else if (!mast5.request && !mast4.request && !mast3.request && mast2.request && mast1.request && mast0.request && counter2_delta < mst2)  begin next_state= master2; end
                        else if (mast5.request && mast4.request && !mast3.request && mast2.request && !mast1.request && !mast0.request && counter2_delta < mst2)  begin next_state= master2; end
                        else if (!mast5.request && mast4.request && !mast3.request && mast2.request && !mast1.request && !mast0.request && counter2_delta < mst2)  begin next_state= master2; end
                        else if (!mast5.request && mast4.request && !mast3.request && mast2.request && !mast1.request && mast0.request && counter2_delta < mst2)  begin next_state= master2; end
                        else if (mast5.request && !mast4.request && mast3.request && mast2.request && !mast1.request && !mast0.request && counter2_delta < mst2)  begin next_state= master2; end
                        else if (!mast5.request && mast4.request && mast3.request && mast2.request && mast1.request && !mast0.request && counter2_delta < mst2)  begin next_state= master2; end
                        else if (mast5.request && !mast4.request && !mast3.request && mast2.request && mast1.request && !mast0.request && counter2_delta < mst2)  begin next_state= master2; end
                        else if (!mast5.request && mast4.request && !mast3.request && mast2.request && mast1.request && mast0.request && counter2_delta < mst2)  begin next_state= master2; end
                        else if (mast5.request && mast4.request && mast3.request && mast2.request && mast1.request && mast0.request && counter2_delta < mst2)  begin next_state= master2; end
                        else if (!mast5.request && mast4.request && mast3.request && mast2.request && !mast1.request && mast0.request && counter2_delta < mst2)  begin next_state= master2; end
                        else if (!mast5.request && mast4.request && !mast3.request && mast2.request && !mast1.request && !mast0.request && counter2_delta == mst2 && counter4_delta == mst4)  begin next_state= master2; end
                        else if (mast5.request && mast4.request && !mast3.request && mast2.request && !mast1.request && mast0.request && counter2_delta == mst2 && counter4_delta == mst4 && counter0_delta == mst0 && counter5_delta == mst5)  begin next_state= master2; end
                        else if (mast5.request && mast4.request && mast3.request && mast2.request && !mast1.request && mast0.request && counter2_delta == mst2 && counter4_delta == mst4 && counter0_delta == mst0 && counter5_delta == mst5 && counter1_delta == mst1)  begin next_state= master2; end
                        else if (!mast5.request && mast4.request && mast3.request && mast2.request && mast1.request && mast0.request && counter2_delta < mst2)  begin next_state= master2; end
                        else if (mast5.request && mast4.request && !mast3.request && mast2.request && mast1.request && mast0.request && counter2_delta < mst2)  begin next_state= master2; end
                        else if (mast5.request && !mast4.request && !mast3.request && mast2.request && !mast1.request && mast0.request && counter2_delta < mst2)  begin next_state= master2; end
                        else if (mast5.request && !mast4.request && mast3.request && mast2.request && !mast1.request && mast0.request && counter2_delta < mst2)  begin next_state= master2; end
                        else if (!mast5.request && mast4.request && !mast3.request && mast2.request && mast1.request && !mast0.request && counter2_delta < mst2)  begin next_state= master2; end
                       
                        
                        else if (!mast5.request && !mast4.request && mast3.request && !mast2.request && !mast1.request && !mast0.request && counter3_delta < mst3)  begin next_state= master3; end
                        else if (!mast5.request && !mast4.request && mast3.request && !mast2.request && mast1.request && !mast0.request && counter3_delta < mst3)  begin next_state= master3; end
                        else if (!mast5.request && !mast4.request && mast3.request && !mast2.request && !mast1.request && !mast0.request && counter3_delta == mst3)  begin next_state= master3; end
                        else if (!mast5.request && mast4.request && mast3.request && !mast2.request && mast1.request && mast0.request && counter3_delta < mst3)  begin next_state= master3; end
                        else if (mast5.request && mast4.request && mast3.request && mast2.request && !mast1.request && mast0.request && counter3_delta < mst3)  begin next_state= master3; end
                        else if (!mast5.request && mast4.request && mast3.request && mast2.request && !mast1.request && !mast0.request && counter3_delta < mst3)  begin next_state= master3; end
                        else if (mast5.request && mast4.request && mast3.request && mast2.request && !mast1.request && !mast0.request && counter3_delta < mst3)  begin next_state= master3; end
                        else if (!mast5.request && mast4.request && mast3.request && mast2.request && !mast1.request && mast0.request && counter3_delta < mst3)  begin next_state= master3; end
                        else if (mast5.request && mast4.request && mast3.request && !mast2.request && mast1.request && mast0.request && counter3_delta < mst3)  begin next_state= master3; end
                        else if (mast5.request && !mast4.request && mast3.request && mast2.request && mast1.request && mast0.request && counter3_delta < mst3)  begin next_state= master3; end
                        else if (!mast5.request && !mast4.request && mast3.request && !mast2.request && !mast1.request && mast0.request && counter3_delta < mst3)  begin next_state= master3; end
                        else if (mast5.request && !mast4.request && mast3.request && mast2.request && mast1.request && !mast0.request && counter3_delta < mst3)  begin next_state= master3; end
                        else if (!mast5.request && mast4.request && mast3.request && !mast2.request && !mast1.request && mast0.request && counter3_delta < mst3)  begin next_state= master3; end
                        else if (!mast5.request && mast4.request && mast3.request && !mast2.request && mast1.request && !mast0.request && counter3_delta < mst3)  begin next_state= master3; end
                        else if (mast5.request && !mast4.request && mast3.request && !mast2.request && !mast1.request && mast0.request && counter3_delta < mst3)  begin next_state= master3; end
                        else if (mast5.request && mast4.request && mast3.request && !mast2.request && mast1.request && !mast0.request && counter3_delta < mst3)  begin next_state= master3; end
                        else if (mast5.request && !mast4.request && mast3.request && !mast2.request && !mast1.request && !mast0.request && counter3_delta < mst3)  begin next_state= master3; end
                        else if (!mast5.request && mast4.request && mast3.request && !mast2.request && !mast1.request && !mast0.request && counter3_delta < mst3)  begin next_state= master3; end
                        else if (mast5.request && mast4.request && mast3.request && !mast2.request && !mast1.request && mast0.request && counter3_delta < mst3)  begin next_state= master3; end
                        else if (!mast5.request && !mast4.request && mast3.request && mast2.request && !mast1.request && !mast0.request && counter3_delta < mst3)  begin next_state= master3; end
                        else if (!mast5.request && !mast4.request && mast3.request && mast2.request && mast1.request && !mast0.request && counter3_delta < mst3)  begin next_state= master3; end
                        else if (!mast5.request && !mast4.request && mast3.request && !mast2.request && mast1.request && mast0.request && counter3_delta < mst3)  begin next_state= master3; end
                        else if (mast5.request && mast4.request && mast3.request && mast2.request && mast1.request && mast0.request && counter3_delta < mst3)  begin next_state= master3; end
                        else if (!mast5.request && !mast4.request && mast3.request && !mast2.request && !mast1.request && mast0.request && counter3_delta == mst3 && counter0_delta == mst0)  begin next_state= master3; end
                        else if (!mast5.request && !mast4.request && mast3.request && mast2.request && !mast1.request && mast0.request && counter3_delta < mst3)  begin next_state= master3; end
                        else if (mast5.request && mast4.request && mast3.request && !mast2.request && !mast1.request && !mast0.request && counter3_delta < mst3)  begin next_state= master3; end
                        else if (!mast5.request && mast4.request && mast3.request && mast2.request && mast1.request && mast0.request && counter3_delta < mst3)  begin next_state= master3; end
                        else if (mast5.request && mast4.request && mast3.request && mast2.request && !mast1.request && mast0.request && counter3_delta == mst3 && counter2_delta == mst2 && counter4_delta == mst4 && counter0_delta == mst0 && counter5_delta == mst5)  begin next_state= master3; end
                        else if (mast5.request && !mast4.request && mast3.request && mast2.request && !mast1.request && !mast0.request && counter3_delta < mst3)  begin next_state= master3; end
                        else if (mast5.request && !mast4.request && mast3.request && !mast2.request && mast1.request && mast0.request && counter3_delta < mst3)  begin next_state= master3; end
                        else if (!mast5.request && mast4.request && mast3.request && mast2.request && mast1.request && !mast0.request && counter3_delta < mst3)  begin next_state= master3; end
                        else if (mast5.request && !mast4.request && mast3.request && mast2.request && !mast1.request && mast0.request && counter3_delta < mst3)  begin next_state= master3; end
                        
                         
                        else if (!mast5.request && !mast4.request && !mast3.request && !mast2.request && mast1.request && !mast0.request && counter1_delta < mst1)  begin next_state= master1; end
                        else if (!mast5.request && !mast4.request && !mast3.request && !mast2.request && mast1.request && !mast0.request && counter1_delta == mst1)  begin next_state= master1; end
                        else if (!mast5.request && !mast4.request && mast3.request && mast2.request && mast1.request && mast0.request && counter1_delta < mst1)  begin next_state= master1; end
                        else if (mast5.request && mast4.request && mast3.request && !mast2.request && mast1.request && !mast0.request && counter1_delta < mst1)  begin next_state= master1; end
                        else if (!mast5.request && mast4.request && !mast3.request && mast2.request && mast1.request && mast0.request && counter1_delta < mst1)  begin next_state= master1; end
                        else if (mast5.request && mast4.request && !mast3.request && mast2.request && mast1.request && mast0.request && counter1_delta < mst1)  begin next_state= master1; end
                        else if (!mast5.request && !mast4.request && !mast3.request && !mast2.request && mast1.request && mast0.request && counter1_delta < mst1)  begin next_state= master1; end
                        else if (mast5.request && mast4.request && !mast3.request && mast2.request && mast1.request && !mast0.request && counter1_delta < mst1)  begin next_state= master1; end
                        else if (!mast5.request && mast4.request && !mast3.request && !mast2.request && mast1.request && !mast0.request && counter1_delta < mst1)  begin next_state= master1; end
                        else if (!mast5.request && !mast4.request && mast3.request && !mast2.request && mast1.request && mast0.request && counter1_delta < mst1)  begin next_state= master1; end
                        else if (mast5.request && mast4.request && !mast3.request && !mast2.request && mast1.request && mast0.request && counter1_delta < mst1)  begin next_state= master1; end
                        else if (mast5.request && !mast4.request && !mast3.request && !mast2.request && mast1.request && !mast0.request && counter1_delta < mst1)  begin next_state= master1; end
                        else if (!mast5.request && !mast4.request && !mast3.request && mast2.request && mast1.request && !mast0.request && counter1_delta < mst1)  begin next_state= master1; end
                        else if (!mast5.request && mast4.request && !mast3.request && mast2.request && mast1.request && !mast0.request && counter1_delta < mst1)  begin next_state= master1; end
                        else if (!mast5.request && !mast4.request && mast3.request && !mast2.request && mast1.request && !mast0.request && counter1_delta < mst1)  begin next_state= master1; end
                        else if (mast5.request && !mast4.request && !mast3.request && !mast2.request && mast1.request && mast0.request && counter1_delta < mst1)  begin next_state= master1; end
                        else if (mast5.request && !mast4.request && mast3.request && !mast2.request && mast1.request && !mast0.request && counter1_delta < mst1)  begin next_state= master1; end
                        else if (mast5.request && mast4.request && !mast3.request && !mast2.request && mast1.request && !mast0.request && counter1_delta < mst1)  begin next_state= master1; end
                        else if (mast5.request && mast4.request && mast3.request && mast2.request && mast1.request && !mast0.request && counter1_delta < mst1)  begin next_state= master1; end
                        else if (mast5.request && mast4.request && mast3.request && mast2.request && mast1.request && mast0.request && counter1_delta < mst1)  begin next_state= master1; end
                        else if (!mast5.request && mast4.request && !mast3.request && !mast2.request && mast1.request && mast0.request && counter1_delta < mst1)  begin next_state= master1; end
                        else if (mast5.request && !mast4.request && !mast3.request && mast2.request && mast1.request && mast0.request && counter1_delta < mst1)  begin next_state= master1; end
                        else if (mast5.request && !mast4.request && !mast3.request && !mast2.request && mast1.request && mast0.request && counter1_delta < mst1)  begin next_state= master1; end
                        else if (!mast5.request && !mast4.request && !mast3.request && mast2.request && mast1.request && mast0.request && counter1_delta < mst1)  begin next_state= master1; end
                        else if (mast5.request && !mast4.request && !mast3.request && mast2.request && mast1.request && !mast0.request && counter1_delta < mst1)  begin next_state= master1; end
                        else if (mast5.request && mast4.request && !mast3.request && !mast2.request && mast1.request && mast0.request && counter1_delta < mst1 )  begin next_state= master1; end
                        else if (mast5.request && mast4.request && mast3.request && mast2.request && mast1.request && mast0.request && counter1_delta < mst1 )  begin next_state= master1; end
                        else if (!mast5.request && !mast4.request && !mast3.request && mast2.request && mast1.request && !mast0.request && counter1_delta == mst1 & counter2_delta== mst2)  begin next_state= master1; end
                        else if (mast5.request && !mast4.request && !mast3.request && mast2.request && !mast1.request && mast0.request && counter1_delta < mst1)  begin next_state= master1; end
                        else if (!mast5.request && !mast4.request && !mast3.request && !mast2.request && mast1.request && mast0.request && counter1_delta == mst1 && counter0_delta == mst0)  begin next_state= master1; end
            end
                           
          

master0 : begin
		
		 mast0.itsyours=1'b1;
		 mast1.itsyours=1'b0;
		 mast2.itsyours=1'b0;
		 mast3.itsyours=1'b0;
		 mast4.itsyours=1'b0;
		 mast5.itsyours=1'b0;
		 //$display (" Acknowledged master0");
		 mast0.Mdin=data_slave_master;
		 mast1.Mdin=0;
		 mast2.Mdin=0;
		 mast3.Mdin=0;
		 mast4.Mdin=0;
		 mast5.Mdin=0;
		 
		
		if(|slave_transfer_done)
			begin
				
                            if(counter0_delta == mst0 )
                                    begin counter=counter_delta+1; end
                            else
                                        begin 
                                        counter0=counter0_delta+1;
                                        counter=counter_delta+1;
                                        end 
                            
                                        next_state=Idle;
                                        mast0.itsyours=0;
                                        mast0.Xend_mstr=1;
                                        {sl6.select_slave,sl5.select_slave,sl4.select_slave,sl3.select_slave,
                                        sl2.select_slave,sl1.select_slave,sl0.select_slave,masl5.select_slave,
                                        masl4.select_slave,masl3.select_slave,masl2.select_slave,masl1.select_slave,masl0.select_slave}=13'b0;
			end
		else
			begin
			next_state=master0;
			counter0=counter0_delta;
			counter=counter_delta;
			mast0.Xend_mstr=0;
			end
			
		 end
	

master1: begin
		
		 mast0.itsyours=1'b0;
		 mast1.itsyours=1'b1;
		 mast2.itsyours=1'b0;
		 mast3.itsyours=1'b0;
		 mast4.itsyours=1'b0;
		 mast5.itsyours=1'b0;
		// $display (" Acknowledged master1");
		 mast1.Mdin=data_slave_master;
		 mast0.Mdin=0;
		 mast2.Mdin=0;
		 mast3.Mdin=0;
		 mast4.Mdin=0;
		 mast5.Mdin=0;
		 
		
		if(|slave_transfer_done)
			begin
					
                            if(counter1_delta == mst1)
                                    begin counter=counter_delta+1; end
                            else 
                                        begin 
                                        counter1=counter1_delta+1;
                                        counter=counter_delta+1;
                                        end 
                         
				next_state=Idle;
				mast1.itsyours=0;
                                 mast1.Xend_mstr=1;
				{sl6.select_slave,sl5.select_slave,sl4.select_slave,sl3.select_slave,sl2.select_slave,sl1.select_slave,sl0.select_slave,
				masl5.select_slave,masl4.select_slave,masl3.select_slave,masl2.select_slave,masl1.select_slave,masl0.select_slave}=13'b0;
			end
	    else
			begin
			next_state=master1;
			counter1=counter1_delta;
			counter=counter_delta;
			 mast0.Xend_mstr=0;
			end
	   end
	  
master2:begin
		
		 mast0.itsyours=1'b0;
		 mast1.itsyours=1'b0;
		 mast2.itsyours=1'b1;
		 mast3.itsyours=1'b0;
		 mast4.itsyours=1'b0;
		 mast5.itsyours=1'b0;
		 //$display (" Acknowledged master2");
		 mast2.Mdin=data_slave_master;
		 mast1.Mdin=0;
		 mast0.Mdin=0;
		 mast3.Mdin=0;
		 mast4.Mdin=0;
		 mast5.Mdin=0;
		 
		
		if(|slave_transfer_done)
			begin
			
					
                            if(counter2_delta == mst2 )
                                    begin counter=counter_delta+1; end
                            else 
                                        begin 
                                        counter2=counter2_delta+1;
                                        counter=counter_delta+1;
                                        end 
                               
				next_state=Idle;
				mast2.itsyours=0;
                                 mast2.Xend_mstr=1;
				{sl6.select_slave,sl5.select_slave,sl4.select_slave,sl3.select_slave,sl2.select_slave,sl1.select_slave,sl0.select_slave,
				masl5.select_slave,masl4.select_slave,masl3.select_slave,masl2.select_slave,masl1.select_slave,masl0.select_slave}=13'b0;
			end
		else
			begin
			next_state=master2;
			counter2=counter2_delta;
			counter=counter_delta;
			 mast2.Xend_mstr=1;
			end
	   end
	  
	
master3: begin
		
		 mast0.itsyours=1'b0;
		 mast1.itsyours=1'b0;
		 mast2.itsyours=1'b0;
		 mast3.itsyours=1'b1;
		 mast4.itsyours=1'b0;
		 mast5.itsyours=1'b0;
		 //$display (" Acknowledged master3");
		 mast3.Mdin=data_slave_master;
		 mast1.Mdin=0;
		 mast2.Mdin=0;
		 mast0.Mdin=0;
		 mast4.Mdin=0;
		 mast5.Mdin=0;
		 
		
		if(|slave_transfer_done)
			begin
					
                            if(counter3_delta == mst3)
                                    begin counter=counter_delta+1; end
                            else 
                                        begin 
                                        counter3=counter3_delta+1;
                                        counter=counter_delta+1;
                                        end 
                               
				next_state=Idle;
				mast3.itsyours=0;
                                 mast3.Xend_mstr=1;
				{sl6.select_slave,sl5.select_slave,sl4.select_slave,sl3.select_slave,sl2.select_slave,sl1.select_slave,sl0.select_slave,
				masl5.select_slave,masl4.select_slave,masl3.select_slave,masl2.select_slave,masl1.select_slave,masl0.select_slave}=13'b0;
			end
		else
			begin
			next_state=master3;
			counter3=counter3_delta;
			counter=counter_delta;
			 mast3.Xend_mstr=0;
			end
	   end
	  
master4: begin
		
		 mast0.itsyours=1'b0;
		 mast1.itsyours=1'b0;
		 mast2.itsyours=1'b0;
		 mast3.itsyours=1'b0;
		 mast4.itsyours=1'b1;
		 mast5.itsyours=1'b0;
		 //$display (" Acknowledged master4");
		 mast4.Mdin=data_slave_master;
		 mast1.Mdin=0;
		 mast2.Mdin=0;
		 mast3.Mdin=0;
		 mast0.Mdin=0;
		 mast5.Mdin=0;
		 
		
		if(|slave_transfer_done)
			begin	
                            if(counter4_delta == mst4)
                                    begin counter=counter_delta+1; end
                            else 
                                        begin 
                                        counter4=counter4_delta+1;
                                        counter=counter_delta+1;
                                        end 
                                
				next_state=Idle;
				mast4.itsyours=0;
                                 mast4.Xend_mstr=1;
				{sl6.select_slave,sl5.select_slave,sl4.select_slave,sl3.select_slave,sl2.select_slave,sl1.select_slave,sl0.select_slave,
				masl5.select_slave,masl4.select_slave,masl3.select_slave,masl2.select_slave,masl1.select_slave,masl0.select_slave}=13'b0;
			end
		else
			begin
			next_state=master4;
			counter4=counter4_delta;
			counter=counter_delta;
			 mast4.Xend_mstr=1;
			end
	   end
	  
	  
master5: begin
		
		 mast0.itsyours=1'b0;
		 mast1.itsyours=1'b0;
		 mast2.itsyours=1'b0;
		 mast3.itsyours=1'b0;
		 mast4.itsyours=1'b0;
		 mast5.itsyours=1'b1;
		 //$display (" Acknowledged master5");
		 
		 mast1.Mdin=0;
		 mast2.Mdin=0;
		 mast3.Mdin=0;
		 mast0.Mdin=0;
		 mast4.Mdin=0;
		 mast5.Mdin=data_slave_master;
		
		if(|slave_transfer_done)
			begin
					
                            if(counter5_delta == mst5 )
                                    begin counter=counter_delta+1; end
                            else  
                                        begin 
                                        counter5=counter5_delta+1;
                                        counter=counter_delta+1;
                                        end 
                                 
				next_state=Idle;
				mast5.itsyours=0;
                                 mast5.Xend_mstr=1;
				{sl6.select_slave,sl5.select_slave,sl4.select_slave,sl3.select_slave,sl2.select_slave,sl1.select_slave,sl0.select_slave,
				masl5.select_slave,masl4.select_slave,masl3.select_slave,masl2.select_slave,masl1.select_slave,masl0.select_slave}=13'b0;
			end
		else
			begin
			next_state=master5;
			counter5=counter5_delta;
			counter=counter_delta;
			 mast5.Xend_mstr=0;
			end
	   end

endcase


//----------------if Acknowledged ----------------------//
	if ({mast5.itsyours,mast4.itsyours,mast3.itsyours,mast2.itsyours,mast1.itsyours,mast0.itsyours}==6'b000001)
				   begin
						address_master_slave = mast0.QmAddr;
						data_master_slave    = mast0.mdout; 
				   end 
				   
	else if ({mast5.itsyours,mast4.itsyours,mast3.itsyours,mast2.itsyours,mast1.itsyours,mast0.itsyours}==6'b000010)
					begin
						address_master_slave = mast1.QmAddr;
						data_master_slave    = mast1.mdout; 
				   end
				   
	else if ({mast5.itsyours,mast4.itsyours,mast3.itsyours,mast2.itsyours,mast1.itsyours,mast0.itsyours}==6'b000100)
					begin
						address_master_slave = mast2.QmAddr;
						data_master_slave    = mast2.mdout; 
				   end 
				   
	else if ({mast5.itsyours,mast4.itsyours,mast3.itsyours,mast2.itsyours,mast1.itsyours,mast0.itsyours}==6'b001000)
				  begin
						address_master_slave = mast3.QmAddr;
						data_master_slave    = mast3.mdout; 
				   end 
				   
	else if ({mast5.itsyours,mast4.itsyours,mast3.itsyours,mast2.itsyours,mast1.itsyours,mast0.itsyours}==6'b010000)
				  begin
						address_master_slave = mast4.QmAddr;
						data_master_slave    = mast4.mdout; 
				   end 
				   
	else if ({mast5.itsyours,mast4.itsyours,mast3.itsyours,mast2.itsyours,mast1.itsyours,mast0.itsyours}==6'b100000)
				 begin
						address_master_slave = mast5.QmAddr;
						data_master_slave    = mast5.mdout; 
				   end 
		
	else if ({mast5.itsyours,mast4.itsyours,mast3.itsyours,mast2.itsyours,mast1.itsyours,mast0.itsyours}==6'b000000)
					begin
						address_master_slave = 48'b0;
						data_master_slave    = 16'b0; 
				   end 

case (address_master_slave) inside

[48'h458affff11cd:48'h458affff1281]: begin
							 	masl0.Adr=address_master_slave;
							 	masl0.select_slave=1;
							 	masl0.dataIn=data_master_slave;
							 	data_slave_master=masl0.dbus_out;
							 	//$display("Slave Selected masl0");
							 end
[48'h2d4bffff63ba:48'h2d4bffff643d]: begin
							 	masl1.Adr=address_master_slave;
							 	masl1.select_slave=1;
							 	masl1.dataIn=data_master_slave;
							 	data_slave_master=masl1.dbus_out;
							 	//$display("Slave Selected masl1");
							 end
[48'h1df3fffff486:48'h1df3fffff4d0]:begin
							 	masl2.Adr=address_master_slave;
							 	masl2.select_slave=1;
							 	masl2.dataIn=data_master_slave;
							 	data_slave_master=masl2.dbus_out;
							 	//$display("Slave Selected masl2");
							 end
[48'h263effff1880:48'h263effff193a]:begin
							 	masl3.Adr=address_master_slave;
							 	masl3.select_slave=1;
							 	masl3.dataIn=data_master_slave;
							 	data_slave_master=masl3.dbus_out;
							 	//$display("Slave Selected masl3");
							 end
[48'h5df8ffffc36e:48'h5df8ffffc3b9]:begin
							 	masl4.Adr=address_master_slave;
							 	masl4.select_slave=1;
							 	masl4.dataIn=data_master_slave;
							 	data_slave_master=masl4.dbus_out;
							 	//$display("Slave Selected masl4");
							 end
[48'h4b82ffff46c4:48'h4b82ffff475a]:begin
							 	masl5.Adr=address_master_slave;
							 	masl5.select_slave=1;
							 	masl5.dataIn=data_master_slave;
							 	data_slave_master=masl5.dbus_out;
							 	//$display("Slave Selected masl5");
							 end


[48'h4d69ffff9a79:48'h4d69ffff9ab4]: begin
								sl0.Adr=address_master_slave;
								sl0.select_slave=1;
								sl0.dataIn=data_master_slave;
								data_slave_master=sl0.dbus_out;
								//$display("Slave Selected sl0");
							 end
							 
[48'h9afffffdb1a :48'h9afffffdb6d ]: begin
								sl1.Adr=address_master_slave;
								sl1.select_slave=1;
								sl1.dataIn=data_master_slave;
								data_slave_master=sl1.dbus_out;
								//$display("Slave Selected sl1");
							 end
[48'h521cffffcce9:48'h521cffffcd1c]:begin
								sl2.Adr=address_master_slave;
								sl2.select_slave=1;
								sl2.dataIn=data_master_slave;
								data_slave_master=sl2.dbus_out;
								//$display("Slave Selected sl2");
							 end
[48'h40bffffa47e :48'h40bffffa55b] :begin
								sl3.Adr=address_master_slave;
								sl3.select_slave=1;
								sl3.dataIn=data_master_slave;
								data_slave_master=sl3.dbus_out;
								//$display("Slave Selected sl3");
							 end
[48'h58b3ffff8bb1:48'h58b3ffff8bd7]:begin
								sl4.Adr=address_master_slave;
								sl4.select_slave=1;
								sl4.dataIn=data_master_slave;
								data_slave_master=sl4.dbus_out;
								//$display("Slave Selected sl4");
							 end
[48'hc60ffffd46b :48'hc60ffffd55b ]:begin
								sl5.Adr=address_master_slave;
								sl5.select_slave=1;
								sl5.dataIn=data_master_slave;
								data_slave_master=sl5.dbus_out;
								//$display("Slave Selected sl5");
							 end
[48'h272dffffe3dc:48'h272dffffe471]:begin
								sl6.Adr=address_master_slave;
								sl6.select_slave=1;
								sl6.dataIn=data_master_slave;
								data_slave_master=sl6.dbus_out;
								//$display("Slave Selected sl6");
							 end


endcase


end
end


//-----------------------------------------------------//

endmodule 

