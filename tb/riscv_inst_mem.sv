module riscv_instr_mem #(
    parameter MEM_SIZE = 1024,  // 1KB memory (256 words)
    parameter LATENCY = 1       // Response latency in cycles
)(
    // Clock and Reset
    input logic        clk,
    input logic        reset_n,
    
    // OBI Instruction Interface
    input  logic        instr_req_i,    // Request
    input  logic [31:0] instr_addr_i,   // Address
    output logic        instr_gnt_o,    // Grant
    output logic        instr_rvalid_o, // Response valid
    output logic [31:0] instr_rdata_o,  // Read data
    // my intf to write in the mem
    input  logic [31:0] addr,
    input  logic [31:0] inst
);

    // Internal memory array
    logic [31:0] mem [0:MEM_SIZE-1];
    
    // Internal signals
    logic [31:0] addr_q;
    logic        pending_req;
    int          response_counter;
    logic [31:0] mem_rdata;
    logic        load=1'b1;

    // Request handling
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            instr_gnt_o <= 0;
            instr_rvalid_o <= 0;
            instr_rdata_o <= '0;
            pending_req <= 0;
            addr_q <= '0;
            load =1'b0;
            response_counter <= 0;
        end else begin
            // Default outputs
            instr_gnt_o <= 0;
            instr_rvalid_o <= 0;

            // Handle new requests
            if (instr_req_i && !pending_req) begin
                instr_gnt_o <= 1;
                addr_q <= instr_addr_i;
                pending_req <= 1;
                response_counter <= LATENCY;
            end
            
            // Count down for response
            if (pending_req) begin
                if (response_counter > 0) begin
                    response_counter <= response_counter - 1;
                end else begin
                    // Response ready
                    instr_rvalid_o <= 1;
                    instr_rdata_o <= mem_rdata;
                    pending_req <= 0;
                    
     
                end
            end
        end
    end

    // Memory read (combinational)
    always_comb begin
        if (addr_q[31:2] < MEM_SIZE) begin
            mem_rdata = mem[addr_q[31:0]]; // Word-aligned access we could use 31:2 lsb 2 bit are always 0
        end else begin
            mem_rdata = 32'h00000013; // Return NOP for out-of-range accesses
        end
    end

    // Memory write (combinational)
     always_comb begin 
        if (load) begin
  // $display("instmem ,time:%0t  : add %0b ,inst %0b" ,$time ,addr,inst);		
         mem[addr] = inst;
        end
     end
   

endmodule