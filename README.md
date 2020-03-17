# discrete-event-simulation
Discrete-event simulation and visualisation of a manufacturing transfer line with 2 machines and 2 queues
![](/architecture.JPG)
* Parts arrive at machine 1 as a Poisson process with rate λ per hour. 
* Machine processing times are exponentially distributed with mean µ1 hours for machine 1 and mean µ2 hours for machine 2. 
* Parts which finish processing at machine 1 move to machine 2 immediately (assume no time is required for parts which finish at machine 1 to arrive at the queue for machine 2). 
* Parts which finish at machine 2 depart the system.

#### Sample Output:
---
![](/sample_output.JPG)
