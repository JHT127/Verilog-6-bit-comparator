//------------------------------------------------------------
//Done by:Joud Thaher 1221381
//6-bit Comparator for both signed and unsigned numbers with synchronization. 
//------------------------------------------------------------
// 6-bit Unsigned Number Comparator Module
// Compares two 6-bit numbers A and B
// Outputs: G (Greater), S (Smaller), E (Equal)
//------------------------------------------------------------
module comparator_unsigned ( A, B, G, S, E );
    input [5:0] A, B;
    output G, S, E;
    
    // Generate inverted signals for comparison
    wire [5:0] notA, notB;

    // Generate NOT gates for each bit
    genvar i;
    generate
        for (i = 0; i < 6; i = i + 1) begin : NOT_GEN
            not #2ns (notA[i], A[i]);
            not #2ns (notB[i], B[i]);
        end
    endgenerate

    // Individual bit comparison signals
    wire G0, L0, G1, L1, G2, L2, G3, L3, G4, L4, G5, L5;
    
    // Generate greater/less comparison for each bit
    and #4ns (G0, A[0], notB[0]);
    and #4ns (L0, B[0], notA[0]); 
    and #4ns (G1, A[1], notB[1]);
    and #4ns (L1, B[1], notA[1]);
    and #4ns (G2, A[2], notB[2]);
    and #4ns (L2, B[2], notA[2]);
    and #4ns (G3, A[3], notB[3]);
    and #4ns (L3, B[3], notA[3]);
    and #4ns (G4, A[4], notB[4]);
    and #4ns (L4, B[4], notA[4]);
    and #4ns (G5, A[5], notB[5]); 
    and #4ns (L5, B[5], notA[5]);

    // Equality signals for each bit
    wire E0, E1, E2, E3, E4, E5;

    // Generate equality comparison for each bit
    nor #3ns (E0, G0, L0);
    nor #3ns (E1, G1, L1);
    nor #3ns (E2, G2, L2);
    nor #3ns (E3, G3, L3);
    nor #3ns (E4, G4, L4);
    nor #3ns (E5, G5, L5);

    // Final equality output
    and #4ns (E, E0, E1, E2, E3, E4, E5); 

    // Greater than propagation signals
    wire GT1, GT2, GT3, GT4, GT5;

    // Generate greater than conditions
    and #4ns (GT1, G0, E1, E2, E3, E4, E5);
    and #4ns (GT2, G1, E2, E3, E4, E5);
    and #4ns (GT3, G2, E3, E4, E5);
    and #4ns (GT4, G3, E4, E5);
    and #4ns (GT5, G4, E5);

    // Final greater than output
    or #4ns (G, G5, GT1, GT2, GT3, GT4, GT5);

    // Less than propagation signals
    wire LT1, LT2, LT3, LT4, LT5;

    // Generate less than conditions
    and #4ns (LT1, L0, E1, E2, E3, E4, E5);
    and #4ns (LT2, L1, E2, E3, E4, E5);
    and #4ns (LT3, L2, E3, E4, E5);
    and #4ns (LT4, L3, E4, E5);
    and #4ns (LT5, L4, E5);  

    // Final less than output
    or #4ns (S, L5, LT1, LT2, LT3, LT4, LT5);	  
	
endmodule

//------------------------------------------------------------
// 6-bit Signed Number Comparator Module
// Compares two 6-bit signed numbers A and B
// Outputs: G (Greater), S (Smaller), E (Equal)
//------------------------------------------------------------
module comparator_signed ( A, B, G, S, E );
    input [5:0] A, B;
    output G, S, E;	
	
    // Generate inverted signals for comparison
    wire [5:0] notA, notB;	
	
    genvar i;
    generate
        for (i = 0; i < 6; i = i + 1) begin : NOT_GEN
            not #2ns (notA[i], A[i]);
            not #2ns (notB[i], B[i]);
        end
    endgenerate	 
	
    // Check if sign bits are equal
    wire x5;
    xnor #5ns (x5, A[5], B[5]); 
	
    // Generate comparison signals for each bit
    wire g4, g3, g2, g1, g0;
    wire e4, e3, e2, e1, e0;
    and #4ns (g4, A[4], notB[4]);
    and #4ns (g3, A[3], notB[3]);
    and #4ns (g2, A[2], notB[2]);
    and #4ns (g1, A[1], notB[1]);
    and #4ns (g0, A[0], notB[0]);
    xnor #5ns (e4, A[4], B[4]);
    xnor #5ns (e3, A[3], B[3]);
    xnor #5ns (e2, A[2], B[2]);
    xnor #5ns (e1, A[1], B[1]);
    xnor #5ns (e0, A[0], B[0]); 
	
    // Greater than conditions
    wire t1, t2, t3, t4, t5, t6;
    and #4ns (t1, notA[5], B[5]);
    and #4ns (t2, x5, A[4], notB[4]);
    and #4ns (t3, x5, e4, A[3], notB[3]);
    and #4ns (t4, x5, e4, e3, A[2], notB[2]);
    and #4ns (t5, x5, e4, e3, e2, A[1], notB[1]);
    and #4ns (t6, x5, e4, e3, e2, e1, A[0], notB[0]);
    or #4ns  (G, t1, t2, t3, t4, t5, t6); 
	
    // Smaller than conditions
    wire s1, s2, s3, s4, s5, s6;
    and #4ns (s1, A[5], notB[5]);
    and #4ns (s2, x5, notA[4], B[4]);
    and #4ns (s3, x5, e4, notA[3], B[3]);
    and #4ns (s4, x5, e4, e3, notA[2], B[2]);
    and #4ns (s5, x5, e4, e3, e2, notA[1], B[1]);
    and #4ns (s6, x5, e4, e3, e2, e1, notA[0], B[0]);
    or #4ns  (S, s1, s2, s3, s4, s5, s6);	
	
    // Final equality output
    and #4ns (E, x5, e4, e3, e2, e1, e0);
	
endmodule

//------------------------------------------------------------
// 2-to-1 Multiplexer Module
// Selects between inputs a and b based on sel signal(to select between signed and unsigned) 
//------------------------------------------------------------
module mux2x1 (a, b, sel, out); 
	input a,b,sel;
	output out;
    wire sel_not, w1, w2;
    
    not #2ns (sel_not, sel);
    and #4ns (w1, a, sel_not);
    and #4ns (w2, b, sel);
    or #4ns  (out, w1, w2); 
	
endmodule		 

//------------------------------------------------------------
// Behavioral Comparator Module
// Implements comparison logic using behavioral Verilog
// Supports both signed and unsigned comparison based on s input
//------------------------------------------------------------
module comparator_beh (
    input [5:0] A, B,
    input s,       // 0 for unsigned, 1 for signed
    input clk,
    output reg G, S, E
);

    reg [5:0] A_reg, B_reg;

    // Register input values
    always @(posedge clk) begin
        A_reg <= A;
        B_reg <= B;
    end

    // Comparison logic
    always @(A_reg or B_reg or s) begin
        if (s) begin // Signed comparison
     
            if ($signed(A_reg) == $signed(B_reg)) begin
                E = 1;
                G = 0;
                S = 0;
            end else if ($signed(A_reg) > $signed(B_reg)) begin
                E = 0;
                G = 1;
                S = 0;
            end else begin
                E = 0;
                G = 0;
                S = 1;
            end
        end else begin  // Unsigned comparison
            if (A_reg == B_reg) begin
                E = 1;
                G = 0;
                S = 0;
            end else if (A_reg > B_reg) begin
                E = 0;
                G = 1;
                S = 0;
            end else begin
                E = 0;
                G = 0;
                S = 1;
            end
        end
    end

endmodule

//------------------------------------------------------------
// D Flip-Flop Module
// Simple D flip-flop with asynchronous reset
//------------------------------------------------------------
module dff (
    input D, 
    input clk, 
    input reset,
    output reg Q
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            Q <= 0;
        else
            Q <= D;
    end
endmodule

//------------------------------------------------------------
// Top-Level Comparator Module with Registers
// Combines structural and behavioral comparators with registers
//------------------------------------------------------------
module comparator_with_registers (
    input [5:0] A, B,
    input s, clk, reset,
    output Greater, Smaller, Equal
);

    // Internal signals
    wire [5:0] A_reg, B_reg;
    wire s_reg;
    wire G_unsigned, S_unsigned, E_unsigned;
    wire G_signed, S_signed, E_signed;
    wire G_mux, S_mux, E_mux;

    // Input registers for A
    dff dff_A0 (.D(A[0]), .clk(clk), .reset(reset), .Q(A_reg[0]));
    dff dff_A1 (.D(A[1]), .clk(clk), .reset(reset), .Q(A_reg[1]));
    dff dff_A2 (.D(A[2]), .clk(clk), .reset(reset), .Q(A_reg[2]));
    dff dff_A3 (.D(A[3]), .clk(clk), .reset(reset), .Q(A_reg[3]));
    dff dff_A4 (.D(A[4]), .clk(clk), .reset(reset), .Q(A_reg[4]));
    dff dff_A5 (.D(A[5]), .clk(clk), .reset(reset), .Q(A_reg[5]));

    // Input registers for B
    dff dff_B0 (.D(B[0]), .clk(clk), .reset(reset), .Q(B_reg[0]));
    dff dff_B1 (.D(B[1]), .clk(clk), .reset(reset), .Q(B_reg[1]));
    dff dff_B2 (.D(B[2]), .clk(clk), .reset(reset), .Q(B_reg[2]));
    dff dff_B3 (.D(B[3]), .clk(clk), .reset(reset), .Q(B_reg[3]));
    dff dff_B4 (.D(B[4]), .clk(clk), .reset(reset), .Q(B_reg[4]));
    dff dff_B5 (.D(B[5]), .clk(clk), .reset(reset), .Q(B_reg[5]));

    // Register for signed/unsigned selection
    dff dff_s (.D(s), .clk(clk), .reset(reset), .Q(s_reg));

    // Instantiate unsigned comparator
    comparator_unsigned comp_unsigned (
        .A(A_reg),
        .B(B_reg),
        .G(G_unsigned),
        .S(S_unsigned),
        .E(E_unsigned)
    );

    // Instantiate signed comparator
    comparator_signed comp_signed (
        .A(A_reg),
        .B(B_reg),
        .G(G_signed),
        .S(S_signed),
        .E(E_signed)
    );

    // Multiplexers to select between signed and unsigned results
    mux2x1 mux_G (
        .a(G_unsigned),
        .b(G_signed),
        .sel(s_reg),
        .out(G_mux)
    );

    mux2x1 mux_S (
        .a(S_unsigned),
        .b(S_signed),
        .sel(s_reg),
        .out(S_mux)
    );

    mux2x1 mux_E (
        .a(E_unsigned),
        .b(E_signed),
        .sel(s_reg),
        .out(E_mux)
    );

    // Output registers
    dff dff_G (.D(G_mux), .clk(clk), .reset(reset), .Q(Greater));
    dff dff_S (.D(S_mux), .clk(clk), .reset(reset), .Q(Smaller));
    dff dff_E (.D(E_mux), .clk(clk), .reset(reset), .Q(Equal));

endmodule

//------------------------------------------------------------
// Testbench for 6-bit Comparator
// Tests both unsigned and signed comparisons
// Verifies structural and behavioral implementations
//------------------------------------------------------------
`timescale 1ns/1ps

module tb_comparator;
    // Test input signals
    reg [5:0] A_unsigned, B_unsigned;          // Unsigned input pairs
    reg signed [5:0] A_signed, B_signed;       // Signed input pairs
    reg s, clk, reset;                         // Control signals

    // Output signals from structural design
    wire G_struc_unsigned, S_struc_unsigned, E_struc_unsigned;  // Unsigned comparison results
    wire G_struc_signed, S_struc_signed, E_struc_signed;        // Signed comparison results

    // Output signals from behavioral design
    wire G_beh_unsigned, S_beh_unsigned, E_beh_unsigned;        // Unsigned comparison results
    wire G_beh_signed, S_beh_signed, E_beh_signed;              // Signed comparison results

    // Test control variables
    integer i, j;                              // Loop counters
    reg pass;                                  // Overall test status

    // Instantiate structural unsigned comparator
    comparator_with_registers dut_struc_unsigned (
        .A(A_unsigned),
        .B(B_unsigned),
        .s(0),                                 // 0 for unsigned mode
        .clk(clk),
        .reset(reset),
        .Greater(G_struc_unsigned),
        .Smaller(S_struc_unsigned),
        .Equal(E_struc_unsigned)
    );

    // Instantiate structural signed comparator
    comparator_with_registers dut_struc_signed (
        .A(A_signed),
        .B(B_signed),
        .s(1),                                 // 1 for signed mode
        .clk(clk),
        .reset(reset),
        .Greater(G_struc_signed),
        .Smaller(S_struc_signed),
        .Equal(E_struc_signed)
    );

    // Instantiate behavioral unsigned comparator
    comparator_beh dut_beh_unsigned (
        .A(A_unsigned),
        .B(B_unsigned),
        .s(0),                                 // 0 for unsigned mode
        .clk(clk),
        .G(G_beh_unsigned),
        .S(S_beh_unsigned),
        .E(E_beh_unsigned)
    );

    // Instantiate behavioral signed comparator
    comparator_beh dut_beh_signed (
        .A(A_signed),
        .B(B_signed),
        .s(1),                                 // 1 for signed mode
        .clk(clk),
        .G(G_beh_signed),
        .S(S_beh_signed),
        .E(E_beh_signed)
    );

    // Test stimulus and verification
    initial begin
        // Initialize test environment
        clk = 0;
        pass = 1;
        reset = 1;
        A_unsigned = 0;
        B_unsigned = 0;
        A_signed = 0;
        B_signed = 0;
        s = 0;
        reset = 0;
    
        // Display header for test results
        $display("  A (Dec)   B (Dec)   s   G_struc   S_struc   E_struc   G_beh   S_beh   E_beh   Match");
        $display("----------------------------------------------------------------------------------");

        // Test unsigned comparisons (0 to 63)
        for (i = 0; i < 64; i = i + 1) begin
            for (j = 0; j < 64; j = j + 1) begin
                A_unsigned = i;
                B_unsigned = j;
				
                // Wait for 3 clock cycles for results to propagate
                @(posedge clk);
                @(posedge clk);   
                @(posedge clk);
				
                // Compare structural and behavioral results
                if ((G_struc_unsigned !== G_beh_unsigned) || 
                    (S_struc_unsigned !== S_beh_unsigned) || 
                    (E_struc_unsigned !== E_beh_unsigned)) begin
                    pass = 0;
                    $display("%9d %9d %3d %9b %9b %9b %9b %9b %9b   Fail", 
                            A_unsigned, B_unsigned, 0, 
                            G_struc_unsigned, S_struc_unsigned, E_struc_unsigned, 
                            G_beh_unsigned, S_beh_unsigned, E_beh_unsigned); 
					$stop;
                end else begin
                    $display("%9d %9d %3d %9b %9b %9b %9b %9b %9b   Pass", 
                            A_unsigned, B_unsigned, 0, 
                            G_struc_unsigned, S_struc_unsigned, E_struc_unsigned, 
                            G_beh_unsigned, S_beh_unsigned, E_beh_unsigned);
                end
            end
        end

        // Test signed comparisons (-32 to 31)
        for (i = -32; i < 32; i = i + 1) begin
            for (j = -32; j < 32; j = j + 1) begin
                A_signed = i;
                B_signed = j;	
				
                // Wait for 3 clock cycles for results to propagate
                @(posedge clk);	
                @(posedge clk); 
                @(posedge clk);
                
                // Compare structural and behavioral results
                if ((G_struc_signed !== G_beh_signed) || 
                    (S_struc_signed !== S_beh_signed) || 
                    (E_struc_signed !== E_beh_signed)) begin
                    pass = 0;
                    $display("%9d %9d %3d %9b %9b %9b %9b %9b %9b   Fail", 
                            A_signed, B_signed, 1, 
                            G_struc_signed, S_struc_signed, E_struc_signed, 
                            G_beh_signed, S_beh_signed, E_beh_signed);	
					$stop;
                end else begin
                    $display("%9d %9d %3d %9b %9b %9b %9b %9b %9b   Pass", 
                            A_signed, B_signed, 1, 
                            G_struc_signed, S_struc_signed, E_struc_signed, 
                            G_beh_signed, S_beh_signed, E_beh_signed);
                end
            end
        end

        // Report final test results
        if (pass) begin
            $display("All test vectors matched! Test Passed.");
        end else begin
            $display("Test Failed!");
        end

        $stop;
    end

    // Generate clock with 26ns period (13ns high, 13ns low)
    always #13ns clk = ~clk;

endmodule