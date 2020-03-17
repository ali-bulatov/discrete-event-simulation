%%% PROBLEM DEFINITION
% Implement a discrete-event simulation of a manufacturing transfer line with 2 machines and 2 queues.
% Parts arrive at machine 1 as a Poisson process with rate ? per hour. 
% Machine processing times are exponentially distributed with mean µ1 hours for machine 1 
%   and mean µ2 hours for machine 2. 
% Parts which finish processing at machine 1 move to machine 2 immediately (assume no time is 
%   required for parts which finish at machine 1 to arrive at the queue for machine 2). 
% Parts which finish at machine 2 depart the system.

%%% IMPLEMENTATION
clear;
clc;

% Constants
lambda = 10;         % Parts arrival rate at machine_1
mu_m1 = 5/60;       % Mean processing time for machine_1
mu_m2 = 5/60;       % Mean processing time for machine_2

% State variables
q = [0 0];               % Queue lengths for machine_1 & machine_2, initially 0
busy = [0 0];            % Machine_1 & machine_2 busy flags, initially false
ave_tot = [0 0];         % Total for ave (time-weighted) queue length calculation
parts_proc = [0 0];      % Total number of parts processed by each machine 


% Timing variables
time = 0;                        % Simulation clock (hours)
max_time = 10000;                % Run the simulation for this many simulated hours
t_part_m1 = expon(1/lambda);     % Time next part will arrive to machine_1
t_m1 = inf;                      % Time machine_1 will finish processing, inf means unknown (no part)
t_m2 = inf;                      % Time machine_2 will finish processing, inf means unknown (no part)
k = 1;                           % Loop counter

% Main simulation loop
while time < max_time
    % Save data (simulation outputs) for plotting later
    t(k) = time;
    x_m1(k) = q(1) + busy(1);  
    x_m2(k) = q(2) + busy(2);   
    k = k + 1;
    
    times = [t_part_m1 t_m1 t_m2];  % Next event times
    [t_min, index] = min(times);
    
    ave_tot(1) = ave_tot(1) + q(1) * (t_min - time);    % Calculate ave_tot for machine_1
    ave_tot(2) = ave_tot(2) + q(2) * (t_min - time);    % Calculate ave_tot for machine_2
    time = t_min;                   % Move simulation clock

    switch index                                    % Index tells use which type of event
        case 1                                      % Process arrival event for queue 1
            if busy(1)
                q(1) = q(1) + 1;                    % Machine_1 is busy, increase queue_1 length
            else            
                busy(1) = true;                     % Machine_1 immediately finished processing 
                parts_proc(1) = parts_proc(1) + 1;  % Increase total amount of parts processed
                q(2) = q(2) + 1;                    % Finished part goes to machine_2 -> increase queue_2 length
                t_m1 = time + expon(mu_m1);         % Time when machine_1 will finish processing 
            end

            t_part_m1 = time + expon(1/lambda);      % Time next part will arrive to machine_1
        case 2                                       % Process departure event for machine_1    
            if q(1) > 0                              % Part waiting for processing?
                q(1) = q(1) - 1;                     % Decrease queue_1 length, machine_1 stays busy
                parts_proc(1) = parts_proc(1) + 1;   % Increase total amount of parts processed
                t_m1 = time + expon(mu_m1);          % Time when machine_1 will finish processing
            else
                busy(1) = false;                     % Not busy
                t_m1 = inf;                          % No parts
            end 
            
            % Process arrival event for queue_2
            if busy(2)
                q(2) = q(2) + 1;                    % Machine_2 is busy, increase queue length
            else            
                busy(2) = true;                     % Machine_2 immediately finished processing
                parts_proc(2) = parts_proc(2) + 1;  % Increase total amount of parts processed
                t_m2 = time + expon(mu_m2);         % Time when machine_2 will finish processing
            end
            
        case 3                                       % Process departure event for machine_2
            if q(2) > 0                              % Part waiting for processing?
                q(2) = q(2) - 1;                     % Decrease queue_2 length, machine_2 stays busy
                parts_proc(2) = parts_proc(2) + 1;   % Increase total amount of parts processed
                t_m2 = time + expon(mu_m2);          % Time when machine_2 will finish processing
            else
                busy(2) = false;                     % Not busy
                t_m2 = inf;                          % No parts
            end 
    end
end


%%% VISUALISATION
% Plot x vs t as a stairstep graph
t(k) = time;  % add last point
x_m1(k) = q(1) + busy(1);
x_m2(k) = q(2) + busy(2);

hold on;               % hold to draw both graphs in 1 figure
stairs(t, x_m1, '-r');
stairs(t, x_m2, '-b');
legend('Machine 1','Machine 2');
title('Manufacturing Transfer Line Simulation');
xlim([0 time]);  % Set x axis limits, y will be auto
xlabel("Time (hours)");
ylabel("Parts in line or being processed");
hold off;

% Finish calculating average queue length (time-weighted average)
ave_q_1 = ave_tot(1)/time;
ave_q_2 = ave_tot(2)/time;
disp("Average queue length for machine 1 is " + ave_q_1);
disp("Average queue length for machine 2 is " + ave_q_2);
% Display average number of parts per hour for each machine
disp("Average number of parts per hour for machine 1 is " + parts_proc(1)/time);
disp("Average number of parts per hour for machine 2 is " + parts_proc(2)/time);

% Returns a positive random number chosen from an exponential distribution with mean value 'mean'.
function e = expon(mean)
    e = -log(rand)*mean;
end