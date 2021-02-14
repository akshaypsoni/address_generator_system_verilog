// System verilog code for address generator with given condition
// condition 1 => Consecutive bit in address should not be 1 (1010010...)
// condition 2 => Number of 1's in the address is equal to 10

class test;

parameter addr_width = 32;		//address width
parameter ones = 10;			//No. of Ones in address
parameter zeros = addr_width - ones;	//No. of Zeros in address

randc int index1[ones];			//array of indices (index1--->1's)
randc int index0[zeros];		//array of indices (index0--->0's)
rand bit [addr_width-1:0]addr;		//address 

//constraint for index1 array
constraint c_index1{

	if(ones<zeros)
	{
	foreach(index1[i])index1[i]<=addr_width-1;	//max range of index
	foreach(index1[i])index1[i]>=0;			//min range of index

	//condition for index1 elements (consecutive indices should not present)
	foreach(index1[i])
		foreach(index1[j])
			if(i!=j)index1[i]!=index1[j]+1;
	
	foreach(index1[i])
		foreach(index1[j])
			if(i!=j)index1[i]!=index1[j]-1;
	
	//condition for repeatition in index1
	foreach(index1[i])
		foreach(index1[j])
			if(i!=j)index1[i]!=index1[j];
	}
}

//constraint for index0 array
constraint c_index0{

	if(ones<zeros)
	{
	foreach(index0[i])index0[i]<=addr_width-1;	//max range of index
	foreach(index0[i])index0[i]>=0;			//min range of index
	
	//condition for index0 elements other than index1 elements
	foreach(index0[i])					
		foreach(index1[j])
			index0[i]!=index1[j];
	
	//condition for repeatition in index0		
	foreach(index0[i])				
		foreach(index0[j])
			if(i!=j)index0[i]!=index0[j];
	}
}

//constraint for addr 
constraint c_addr{

	if(ones==zeros)
	{
		//alternate 1 & 0 or 0 & 1
		foreach(addr[i])
			if(i>0)addr[i]!=addr[i-1];
	
	}
	else
	{
		//assigning 1 in addr at indices present in index1
		foreach(index1[i])
			foreach(addr[j])
				if(j==index1[i])
					addr[j]==1'b1;
					
		//assigning 0 in addr at indices present in index0		
		foreach(index0[i])
			foreach(addr[j])
				if(j==index0[i])
					addr[j]==1'b0;
					
	}		
}


function void pre_randomize();
	if(ones==zeros)
		$display("same ones and zeros");	
	else
		$display("ones:%0d, Zeros:%0d",ones,zeros);
endfunction
	
function void display();
	if(ones!=zeros)
	begin
		$display("index1=%p, size:%0d",index1,ones);
		$display("index0=%p, size:%0d",index0,zeros);
	end
	$display("address= %b",addr);
	$display("--------------------------------------------------------------------------------------------");
endfunction


endclass


module top;

test t;

initial begin
//t = new();
	repeat(5) begin
		t = new();
		assert(t.randomize());
		t.display;	
	end
end



endmodule
