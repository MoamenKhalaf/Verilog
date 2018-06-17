
/* ------------- single cycle mips processor --------------- */
// it contains two basic mmodules ( datapath module and control module )
/* the first module (datapath) responsible to creat the path for the instruction which is excuted
and determine the address of the next instruction to be excuted according to the current instruction
if R-type instruction the next addres PC+4,
if beq instruction teh next addres determined by the number of instruction between PC+4 and the target
which is specified at the imm field,
if jump instruction the next address is determined by the 26-bit imm stored at the sddr field.*/
/* the second module (control) is responsible to creat all the control signals which control the excution of the program*/  
// in single cycle mips only one cycle is needed to excute each instruction cycle/instruction (CPI)=1

module MIPS (clk , reset , intrface1 , intrface2 , intrface3);

	input
		clk, // the main system clock
		reset; // reset input signal for the initialization

	inout [31:0] intrface1;
	inout [31:0] intrface2;
	inout [31:0] intrface3;

	wire [31:0] readdata;
	wire [31:0] address;
	wire [31:0] writedata;

	wire [2:0] WE;

	wire WEM;

	wire [1:0] RDSel;

	wire [31:0] RDM;
	wire [31:0] RD1;
	wire [31:0] RD2;
	wire [31:0] RD3;


	wire
		regwrite, // enable for register file writing operation 
		regdst, // selector for the mux that sellect the instruction type destination register (rt ==> i-type rd ==> r-type)
		ALUSrc,  // selector for the mux that sellect the instruction type operand source (imm ==> i-type rs|rt ==> r-type)
		branch,	// control signal that sellect PC' whether PC'=PC+4+signimm*4 for beq instruction or PC+4for the others.
		memwrite,	//enable for data memory writing operation 
		memtoreg, /* selector for the mux that sellect WD for the register file whether data 
			        from memory for lw,sw instructions or ALUresult for the others.*/
		jump; // selector for the mux which select PC', it is asserted only in case of jump instruction

	wire [2:0] ALUControl; // 3-bit selector to select which operation to perform


	wire [5:0] op; // operation code field that specifies which type of instruction to be excutes
	wire [3:0] funct; // function field which specifies the function to perform in R-type instruction

  // controller unnit specifies the control signals to control the excution of the instruction.
	controller_unit c1 (op , funct , regwrite , regdst , ALUSrc , branch , memwrite , memtoreg , ALUControl , jump);
	
	// datapath determine the path of each instruction. it is contolled by the contol signals from contoller unit.
	data_path d1 (clk , reset , regwrite , regdst , ALUSrc , ALUControl , branch , memtoreg , jump , op , funct , address , writedata , readdata);

	data_memory data_memory1 (clk , reset , address , RDM , writedata , WEM);

	address_decoder address1 (memwrite , address , WE , WEM , RDSel);

	device_IO IO1 (clk , writedata , WE [0] , RD1 , intrface1 [7:0]);

	device_IO IO2 (clk , writedata , WE [1] , RD2 , intrface2);

	device_IO IO3 (clk , writedata , WE [2] , RD3 , intrface3);

	mux_IO mux1 (RDM , RD1 , RD2 , RD3 , RDSel , readdata);



endmodule