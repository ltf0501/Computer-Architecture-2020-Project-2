# 2020 NTU CSIE Computer Architecture Project 2 - Pipelined CPU with 2-way Associative Cache

### Task
* Use Verilog to construct a pipelined CPU supporting the following instructions.
	+ and
	+ xor
	+ sll
	+ add
	+ sub
	+ mul
	+ addi
	+ srai
	+ lw
	+ sw
	+ beq

* Data hazard and control hazard are needed to be considered.
* Instead of directly accessing the data memory like in project 1, this project adds the cache between CPU and data memory. We use *write back/write allocate* policies when *write hit/write miss* happens.
* For more specification, see <a href="https://github.com/ltf0501/Computer-Architecture-2020-Project-2/blob/master/spec/CA2020_project1_spec.pdf"> spec.pdf </a>

### Report
See <a href="https://github.com/ltf0501/Computer-Architecture-2020-Project-2/blob/master/report.pdf"> report.pdf </a>
