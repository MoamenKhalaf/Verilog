module pipetemp (clk , reset , rx , sensor , tx , warning , shutdown);


	input 
		clk,
		reset, 
		rx;

	inout [7:0] sensor;

	output 
		tx,
		warning,
		shutdown;

	wire [31:0] I2o;
	
	assign shutdown = I2o [11];
	assign warning = I2o [12];


	uart uart1 (tx , rx , clk , reset , I2o [8] ,, I2o [7:0] ,,, I2o [10:9]);
	MIPS mips1 (clk , reset , sensor , I2o ,);


endmodule