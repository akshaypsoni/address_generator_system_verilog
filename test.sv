class test;
	rand bit [31:0]addr;
	randc int index;
	int q[$];		//queue for storing random index
	int count=0;
	int flag=0;

	//constraint for index array
	constraint c_index{
		
		index>=0;		//min range of index
		index<=31;		//max range of index
		
		//condition for index elements (consecutive indices should not present)
		foreach(q[i])index!=q[i]+1;
		foreach(q[i])index!=q[i]-1;
		
		//condition for repeatition of index in queue
		foreach(q[i])index!=q[i];

	}

	//constraint for addr 
	constraint c_addr{

		foreach(addr[j])
			if((j==q[0])||(j==q[1])||(j==q[2])||(j==q[3])||(j==q[4])||(j==q[5])||(j==q[6])||(j==q[7])||(j==q[8])||(j==q[9]))
				addr[j]==1'b1;
			else addr[j]==1'b0;
	}
	

	
	function void addr_randomize();
		//enable index and index constraint & disable addr and addr constraint
		flag=0;
		index.rand_mode(1);
		c_index.constraint_mode(1);
		addr.rand_mode(0);
		c_addr.constraint_mode(0);
		
		repeat(10) 
		begin
			assert(randomize());	//randomize index		
		end
		$display("index=%p, count=%0d",q,count);
		
		//disable index and index constraint & enable addr and addr constraint
		flag=1;			//random indices generated
		index.rand_mode(0);
		c_index.constraint_mode(0);
		addr.rand_mode(1);
		c_addr.constraint_mode(1);

		assert(randomize());	//randomize addr
		
	endfunction
	
	
	function void post_randomize();
	//flag=0 ---> randomizing index
		if(flag==0)
		begin
			if(count==10)
			begin
				q.delete();
				count=0;
			end
			q.push_back(index);	//index generated push_back to queue
			count++;
		end
	endfunction
	
	function void display();
		$display("addr=%b",addr);
		$display("-----------------------------------------------------------------");			
	endfunction

endclass


module top;

test t;

initial begin
	t = new();
	
	repeat(5) 
	begin
		t.addr_randomize();
		t.display();
	end
	
end


endmodule