	.data 0x10000000
path: .asciiz "test.exe"
	## File inftest.exe must be exist ##
pathi: .asciiz "inftest.exe"
	## Size of file ##
buffer: .space 6000000
	.globl __start
    .text 0x00400000
	
__start: # Open File Read#
		 la $a0,path
		 li $a1,0
		 jal _openFile	
	 
		 ## Read File ##
		 jal _readFile
		 
		 ## Change EP ##
		 jal _change
		 
		 ## Close Exe ##
		 jal _close
		 
		 ## Open File Write ##
		 la $a0,pathi
		 li $a1,1
		 jal _openFile
		 
		 ## Rewrite Exe ##
		 jal _write
		 
		 ## Close Exe ##
		 jal _close
		 
		 ## Print Test##
		 #jal _print
		 
		 ## Exit ##
		 li $v0,10
		 syscall

_write:  li $v0,15
		 move $a0,$s6
		 la $a1,buffer
		 li $a2,6000000
		 syscall
		 jr $ra
		 
_change:   la $a0,buffer
		   addu $a0,$a0,0x0A8 # EP offset
		   ## Save 1st byte of ep address ##
		   li $a1,0x3c
		   sb $a1,0($a0)
		   ## You can modify all bytes of 32bit address chaining the instructions appeared before ##
		   jr $ra 
		 
_openFile: li $v0,13
		   la $a2,0
		   syscall
		   move $s6,$v0 # Saving descriptor
		   jr $ra	

_readFile: li $v0,14
		   move $a0,$s6 # $a0 -> descriptor
		   la $a1,buffer
		   li $a2,6000000
		   syscall
		   jr $ra
		   
_close: li $v0, 16
		move $a0,$s6
		syscall
		jr $ra
		
_print: li $t0,6000000
		li $v0,11
     	la $t1,buffer
loop:	lb $a0,0($t1)
		syscall
		addiu $t0,-1
		addiu $t1,1
		bne $t0,$zero,loop
		jr $ra		 