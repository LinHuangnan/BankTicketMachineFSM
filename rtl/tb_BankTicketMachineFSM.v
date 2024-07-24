module tb_BankTicketMachineFSM;

    // Inputs
    reg clk;
    reg rst_n;
    reg [2:0] service_ButtonPress;
    reg [3:0] officer_ButtonPress;

    // Outputs
    wire [6:0] Tickernum;
    wire [1:0] Desknum;
    wire [15:0] ticket_WaitingCustomers;
    wire [2:0] ticket_ServiceType;

    // Instantiate the module under test
    BankTicketMachineFSM dut (
        .clk(clk),
        .rst_n(rst_n),
        .service_ButtonPress(service_ButtonPress),
        .officer_ButtonPress(officer_ButtonPress),
        .Tickernum(Tickernum),
        .Desknum(Desknum),
        .ticket_WaitingCustomers(ticket_WaitingCustomers),
        .ticket_ServiceType(ticket_ServiceType)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // Reset generation
    initial begin
        clk = 0;
        rst_n = 0;
        service_ButtonPress = 0;
        officer_ButtonPress = 0;
        #10 rst_n = 1;
    end

    // Stimulus
    initial begin
        // First state is IDLE
        // No button press, so outputs should remain at their initial values
        // Wait for some time
        #20;
        // Press general services button
        service_ButtonPress = 3'b001;
        #20;
        // Press general services button again
        service_ButtonPress = 3'b001;
        #20;
        // Press general services button again
        service_ButtonPress = 3'b001;
        #20;
        // Press general services button again
        service_ButtonPress = 3'b001;
        #20;
        // Press loan services button 
        service_ButtonPress = 3'b010;
        #20;
        // Press loan services button again
        service_ButtonPress = 3'b010;
        #20;
        // Press coustemer service button
        service_ButtonPress = 3'b100;
        #20;
        // Press coustemer service button again
        service_ButtonPress = 3'b100;

        // Wait for some time
        #20;
        service_ButtonPress = 3'b000;

        // Press officer 1 button
        officer_ButtonPress = 4'b0001;

        // Wait for some time
        #20;

        // Press officer 1 button
        officer_ButtonPress = 4'b0001;

        // Wait for some time
        #20;

        // Press officer 2 button
        officer_ButtonPress = 4'b0010;

        // Wait for some time
        #20;

        // Press officer 2 button
        officer_ButtonPress = 4'b0010;

        // Wait for some time
        #20;

        // Press officer 3 button
        officer_ButtonPress = 4'b0100;

        // Wait for some time
        #20;

        // Press officer 4 button
        officer_ButtonPress = 4'b1000;

        // Wait for some time
        #20;

        // Press no button
        officer_ButtonPress = 4'b0000;

        // Wait for some time
        #20;

    end

endmodule